import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

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

    final cipher = ECBBlockCipher(AESEngine());
    final params = KeyParameter(keyBytes);
    
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddedCipher.init(false, PaddedBlockCipherParameters(params, null));

    final decrypted = paddedCipher.process(encryptedBytes);
    return utf8.decode(decrypted);
  }

  /// RSA加密
  static String _rsaEncrypt(String text, String publicKeyStr) {
    // 使用从原项目提取的正确模数和指数
    final modulus = BigInt.parse(
      '157794750267131502212476817800345498121872778333338974742401153102536627753526253991370180629076664791894775335978549868031942539786603299419807860772432806427833685472618792592200595694346872951301770558076513534925959016749053613808246968063851641659421666292583491302576850012481721883253165867073016432307');
    final exponent = BigInt.from(65537);
    
    final rsaPublicKey = RSAPublicKey(modulus, exponent);
    
    // 执行RSA加密（无填充，对应原项目的'NONE'）
    final cipher = RSAEngine();
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));
    
    final textBytes = Uint8List.fromList(utf8.encode(text));
    final encrypted = cipher.process(textBytes);
    
    return _bytesToHex(encrypted);
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
  static Map<String, dynamic> eapiReqDecrypt(String encryptedParams) {
    final decryptedData = aesDecrypt(encryptedParams, eapiKey, '', format: 'hex');
    final regex = RegExp(r'(.*?)-36cd479b6b5-(.*?)-36cd479b6b5-(.*)');
    final match = regex.firstMatch(decryptedData);
    
    if (match != null) {
      final url = match.group(1)!;
      final data = jsonDecode(match.group(2)!);
      final md5Hash = match.group(3)!;
      
      return {
        'url': url,
        'data': data,
        'md5': md5Hash,
      };
    }
    
    throw Exception('Failed to decrypt EAPI request');
  }

  /// 生成随机密钥
  static String _generateSecretKey() {
    final random = Random();
    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      buffer.write(base62[random.nextInt(base62.length)]);
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
