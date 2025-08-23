import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';
import 'package:asn1lib/asn1lib.dart';

class CryptoHelper {
  static const String iv = '0102030405060708';
  static const String presetKey = '0CoJUm6Qyw8W8jud';
  static const String linuxapiKey = 'rFgB&h#%2?^eDg:Q';
  static const String base62 = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static const String eapiKey = 'e82ckenh8dichen8';
  static const String publicKey = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB
-----END PUBLIC KEY-----''';

  /// AES加密
  static String aesEncrypt(String text, String mode, String key, String ivParam, {String format = 'base64'}) {
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final ivBytes = Uint8List.fromList(utf8.encode(ivParam));
    final textBytes = Uint8List.fromList(utf8.encode(text));

    late BlockCipher cipher;
    late CipherParameters params;

    if (mode.toLowerCase() == 'cbc') {
      cipher = CBCBlockCipher(AESEngine());
      params = ParametersWithIV(KeyParameter(keyBytes), ivBytes);
    } else {
      cipher = ECBBlockCipher(AESEngine());
      params = KeyParameter(keyBytes);
    }

    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddedCipher.init(true, PaddedBlockCipherParameters(params, null));

    final encrypted = paddedCipher.process(textBytes);
    
    if (format == 'base64') {
      return base64.encode(encrypted);
    } else {
      return _bytesToHex(encrypted).toUpperCase();
    }
  }

  /// AES解密
  static String aesDecrypt(String ciphertext, String key, String ivParam, {String format = 'base64'}) {
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    
    Uint8List encryptedBytes;
    if (format == 'base64') {
      encryptedBytes = base64.decode(ciphertext);
    } else {
      encryptedBytes = _hexToBytes(ciphertext);
    }

    // JavaScript版本始终使用ECB模式进行解密
    final cipher = ECBBlockCipher(AESEngine());
    final params = KeyParameter(keyBytes);
    
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddedCipher.init(false, PaddedBlockCipherParameters(params, null));

    final decrypted = paddedCipher.process(encryptedBytes);
    return utf8.decode(decrypted);
  }

  /// RSA加密
  static String _rsaEncrypt(String text, String publicKeyStr) {
    // 解析PEM格式的公钥
    final rsaPublicKey = _parsePublicKeyFromPem(publicKeyStr);
    
    // 执行RSA加密（无填充，对应原项目的'NONE'）
    final cipher = RSAEngine();
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));
    
    final textBytes = Uint8List.fromList(utf8.encode(text));
    final encrypted = cipher.process(textBytes);
    
    return _bytesToHex(encrypted);
  }

  /// 从PEM格式解析RSA公钥
  static RSAPublicKey _parsePublicKeyFromPem(String pemString) {
    // 移除PEM头尾和换行符
    final keyData = pemString
        .replaceAll('-----BEGIN PUBLIC KEY-----', '')
        .replaceAll('-----END PUBLIC KEY-----', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .trim();
    
    // Base64解码
    final keyBytes = base64.decode(keyData);
    
    // 使用ASN1解析器解析DER格式的公钥
    final asn1Parser = ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    
    // 获取公钥位串
    final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;
    
    // 解析公钥位串中的RSA公钥
    final publicKeyBytes = publicKeyBitString.contentBytes();
    final publicKeyParser = ASN1Parser(publicKeyBytes);
    final publicKeySeq = publicKeyParser.nextObject() as ASN1Sequence;
    
    final modulus = (publicKeySeq.elements[0] as ASN1Integer).valueAsBigInteger;
    final exponent = (publicKeySeq.elements[1] as ASN1Integer).valueAsBigInteger;
    
    return RSAPublicKey(modulus, exponent);
  }

  /// Web API加密
  static Map<String, String> weapi(Map<String, dynamic> object) {
    final text = jsonEncode(object);
    
    // 生成16位随机密钥
    final secretKey = _generateSecretKey();
    
    // 第一次AES加密：使用预设密钥
    final firstEncrypt = aesEncrypt(text, 'cbc', presetKey, iv);
    
    // 第二次AES加密：使用随机密钥
    final params = aesEncrypt(firstEncrypt, 'cbc', secretKey, iv);
    
    // RSA加密：将密钥反转后加密
    final reversedKey = secretKey.split('').reversed.join('');
    final encSecKey = _rsaEncrypt(reversedKey, publicKey);
    
    return {
      'params': params,
      'encSecKey': encSecKey,
    };
  }

  /// Linux API加密
  static Map<String, String> linuxapi(Map<String, dynamic> object) {
    final text = jsonEncode(object);
    return {
      'eparams': aesEncrypt(text, 'ecb', linuxapiKey, '', format: 'hex'),
    };
  }

  /// EAPI加密
  static Map<String, String> eapi(String url, dynamic object) {
    final text = object is String ? object : jsonEncode(object);
    final message = 'nobody${url}use${text}md5forencrypt';
    final digest = md5.convert(utf8.encode(message)).toString();
    final data = '$url-36cd479b6b5-$text-36cd479b6b5-$digest';
    
    return {
      'params': aesEncrypt(data, 'ecb', eapiKey, '', format: 'hex'),
    };
  }

  /// EAPI响应解密
  static Map<String, dynamic> eapiResDecrypt(String encryptedParams) {
    final decryptedData = aesDecrypt(encryptedParams, eapiKey, '', format: 'hex');
    return jsonDecode(decryptedData);
  }

  /// EAPI请求解密
  static Map<String, dynamic>? eapiReqDecrypt(String encryptedParams) {
    final decryptedData = aesDecrypt(encryptedParams, eapiKey, '', format: 'hex');
    final regex = RegExp(r'(.*?)-36cd479b6b5-(.*?)-36cd479b6b5-(.*)');
    final match = regex.firstMatch(decryptedData);
    
    if (match != null) {
      final url = match.group(1)!;
      final data = jsonDecode(match.group(2)!);
      
      return {
        'url': url,
        'data': data,
      };
    }
    
    // 如果没有匹配到，返回null
    return null;
  }

  /// 通用解密函数
  static String decrypt(String cipher) {
    return aesDecrypt(cipher, eapiKey, '', format: 'hex');
  }

  /// 生成随机密钥
  static String _generateSecretKey() {
    final random = Random();
    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      // 使用Math.round(Math.random() * 61)的等价实现
      buffer.write(base62[(random.nextDouble() * 62).round() % 62]);
    }
    return buffer.toString();
  }

  /// 字节转十六进制
  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  /// 十六进制转字节
  static Uint8List _hexToBytes(String hex) {
    final result = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(result);
  }
}
