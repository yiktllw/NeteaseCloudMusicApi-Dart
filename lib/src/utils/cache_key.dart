import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

/// 生成缓存键
/// 基于 https://rocka.me/article/netease-cloud-music-cache-key-reverse 的实现
/// 精确复制 Node.js 版本的逻辑
String encode(Map<String, dynamic> params) {
  // 按字符的 Unicode 代码点对键进行排序（与 JS 的 codePointAt(0) 对应）
  final keys = params.keys.toList()
    ..sort((a, b) {
      // 使用 runes 来获取 Unicode 代码点，类似 JS 的 codePointAt(0)
      final aCodePoint = a.runes.first;
      final bCodePoint = b.runes.first;
      return aCodePoint - bCodePoint;
    });
  
  // 创建有序的参数映射（保持原始值类型）
  final record = <String, dynamic>{};
  for (final k in keys) {
    record[k] = params[k];
  }
  
  // 构建查询字符串（完全模拟 Node.js 的 querystring.stringify 行为）
  // Node.js querystring.stringify 不会对基本字符进行编码
  final parts = <String>[];
  for (final entry in record.entries) {
    final key = entry.key;
    final value = entry.value.toString();
    parts.add('$key=$value');
  }
  final text = parts.join('&');
  
  // 使用 AES-128-ECB 加密
  final keyString = ')(13daqP@ssw0rd~';
  
  // 确保密钥长度正确（16字节用于AES-128）
  final keyBytes = Uint8List(16);
  final keyStringBytes = utf8.encode(keyString);
  for (int i = 0; i < 16; i++) {
    keyBytes[i] = i < keyStringBytes.length ? keyStringBytes[i] : 0;
  }
  
  final textBytes = utf8.encode(text);
  
  // 创建 AES 加密器
  final cipher = AESEngine()
    ..init(true, KeyParameter(keyBytes));
  
  // 手动实现 ECB 模式和 PKCS7 填充
  final blockSize = 16; // AES block size
  final paddedData = _addPKCS7Padding(textBytes, blockSize);
  
  final encryptedData = <int>[];
  
  // 逐块加密
  for (int i = 0; i < paddedData.length; i += blockSize) {
    final block = paddedData.sublist(i, i + blockSize);
    final encryptedBlock = Uint8List(blockSize);
    cipher.processBlock(Uint8List.fromList(block), 0, encryptedBlock, 0);
    encryptedData.addAll(encryptedBlock);
  }
  
  return base64.encode(encryptedData);
}

/// 添加 PKCS7 填充
List<int> _addPKCS7Padding(List<int> data, int blockSize) {
  final paddingLength = blockSize - (data.length % blockSize);
  final paddedData = List<int>.from(data);
  
  for (int i = 0; i < paddingLength; i++) {
    paddedData.add(paddingLength);
  }
  
  return paddedData;
}

/// 为指定ID生成缓存键
/// 
/// [id] 专辑或其他资源的ID
/// 返回生成的缓存键
String generateCacheKey(String id) {
  return encode({
    'id': id,
    'e_r': true,
  });
}
