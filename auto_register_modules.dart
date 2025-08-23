import 'dart:io';

void main() async {
  print('=== 自动模块注册脚本 ===\n');

  // 扫描modules目录
  final modulesDir = Directory('lib/src/modules');
  if (!await modulesDir.exists()) {
    print('❌ modules目录不存在');
    return;
  }

  final moduleFiles = <String>[];
  final moduleNames = <String>[];
  final imports = <String>[];
  final registrations = <String>[];

  await for (final entity in modulesDir.list()) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final fileName = entity.path.split('/').last.split('\\').last;
      if (fileName != '.DS_Store') {
        moduleFiles.add(fileName);
        print('发现模块文件: $fileName');
        
        // 读取文件内容分析函数
        final content = await entity.readAsString();
        final functions = _extractFunctions(content);
        
        for (final func in functions) {
          moduleNames.add(func);
          print('  - 发现函数: $func');
        }
        
        imports.add("import '../modules/$fileName';");
      }
    }
  }

  // 生成注册代码
  print('\n=== 生成注册代码 ===');

  // 为每个模块生成注册调用
  for (final moduleName in moduleNames) {
    final registrationCall = "    ModuleRegistry.register('$moduleName', $moduleName);";
    registrations.add(registrationCall);
  }

  // 生成完整的中间文件
  await _generateAutoRegisterFile(imports, registrations, moduleNames);

  print('\n✅ 自动注册完成！');
  print('发现 ${moduleFiles.length} 个模块文件');
  print('注册 ${moduleNames.length} 个API函数');
  print('生成的中间文件: lib/src/utils/auto_register.dart');
}

/// 从文件内容中提取函数名
List<String> _extractFunctions(String content) {
  final functions = <String>[];
  final lines = content.split('\n');
  
  for (final line in lines) {
    // 匹配 Future<Map<String, dynamic>> functionName( 模式
    final match = RegExp(r'Future<Map<String, dynamic>>\s+(\w+)\s*\(').firstMatch(line);
    if (match != null) {
      final functionName = match.group(1)!;
      // 排除私有函数、一些特殊函数和无效的函数名
      if (!functionName.startsWith('_') && 
          functionName != 'main' && 
          functionName != 'Function' &&  // 排除 Function 类型
          !functionName.startsWith('register') &&
          functionName.length > 1) {  // 确保不是单个字符
        functions.add(functionName);
      }
    }
  }
  
  return functions;
}

/// 生成自动注册中间文件
Future<void> _generateAutoRegisterFile(
  List<String> imports, 
  List<String> registrations, 
  List<String> moduleNames
) async {
  final autoRegisterContent = '''// 自动生成的模块注册文件
// 请勿手动编辑此文件，运行 tools/auto_register_modules.dart 重新生成

import 'module_registry.dart';
${imports.join('\n')}

/// 自动注册所有API模块
class AutoRegister {
  static bool _registered = false;
  
  /// 注册所有模块
  static void registerAllModules() {
    if (_registered) return;
    
    print('正在注册 ${moduleNames.length} 个API模块...');
    
${registrations.join('\n')}
    
    _registered = true;
    print('✅ 所有模块注册完成');
  }
  
  /// 获取所有已注册的模块名称
  static List<String> getRegisteredModuleNames() {
    return [
${moduleNames.map((name) => "      '$name',").join('\n')}
    ];
  }
  
  /// 获取模块总数
  static int getModuleCount() => ${moduleNames.length};
}
''';

  final autoRegisterFile = File('lib/src/utils/auto_register.dart');
  await autoRegisterFile.writeAsString(autoRegisterContent);
  print('✅ 自动注册文件已生成: ${autoRegisterFile.path}');
}
