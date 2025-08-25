// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math' as math;

/// 模块信息
class ModuleInfo {
  final String name;
  final String fileName;
  final List<String> parameters;
  final List<String> requiredParameters;
  final String? description;

  ModuleInfo({
    required this.name,
    required this.fileName,
    required this.parameters,
    required this.requiredParameters,
    this.description,
  });
}

void main() async {
  print('=== 自动模块注册脚本 ===\n');

  // 扫描modules目录
  final modulesDir = Directory('lib/src/modules');
  if (!await modulesDir.exists()) {
    print('❌ modules目录不存在');
    return;
  }

  final moduleFiles = <String>[];
  final moduleInfos = <ModuleInfo>[];
  final imports = <String>[];
  final registrations = <String>[];

  await for (final entity in modulesDir.list()) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final fileName = entity.path.split('/').last.split('\\').last;
      if (fileName != '.DS_Store') {
        moduleFiles.add(fileName);
        print('发现模块文件: $fileName');
        
        // 读取文件内容分析函数和参数
        final content = await entity.readAsString();
        final modules = _extractModuleInfo(content, fileName);
        
        for (final module in modules) {
          moduleInfos.add(module);
          print('  - 发现函数: ${module.name}');
          print('    参数: ${module.parameters.join(', ')}');
          if (module.requiredParameters.isNotEmpty) {
            print('    必需参数: ${module.requiredParameters.join(', ')}');
          }
        }
        
        imports.add("import '../modules/$fileName';");
      }
    }
  }

  // 生成注册代码
  print('\n=== 生成注册代码 ===');

  // 为每个模块生成注册调用
  for (final module in moduleInfos) {
    final registrationCall = "    ModuleRegistry.register('${module.name}', ${module.name});";
    registrations.add(registrationCall);
  }

  // 生成完整的中间文件
  await _generateAutoRegisterFile(imports, registrations, moduleInfos.map((m) => m.name).toList());
  
  // 生成增强的API常量文件
  await _generateEnhancedApiConstantsFile(moduleInfos);

  print('\n✅ 自动注册完成！');
  print('发现 ${moduleFiles.length} 个模块文件');
  print('注册 ${moduleInfos.length} 个API函数');
  print('生成的中间文件: lib/src/utils/auto_register.dart');
  print('生成的增强API常量文件: lib/src/utils/api_constants.dart');
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
    
${registrations.join('\n')}
    
    _registered = true;
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

/// 从文件内容中提取模块信息（包括参数）
List<ModuleInfo> _extractModuleInfo(String content, String fileName) {
  final modules = <ModuleInfo>[];
  final lines = content.split('\n');
  
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    
    // 匹配函数定义
    final patterns = [
      RegExp(r'Future<Map<String, dynamic>>\s+(\w+)\s*\('),
      RegExp(r'Future<[^>]+>\s+(\w+)\s*\('),
      RegExp(r'Map<String, dynamic>\s+(\w+)\s*\('),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final functionName = match.group(1)!;
        
        // 排除私有函数等
        if (!functionName.startsWith('_') && 
            functionName != 'main' && 
            functionName != 'Function' &&
            !functionName.startsWith('register') &&
            functionName.length > 1) {
          
          // 提取函数描述
          String? description;
          if (i > 0) {
            final prevLine = lines[i - 1].trim();
            if (prevLine.startsWith('///')) {
              description = prevLine.substring(3).trim();
            }
          }
          
          // 分析函数参数
          final paramInfo = _analyzeFunctionParameters(content, functionName);
          
          modules.add(ModuleInfo(
            name: functionName,
            fileName: fileName,
            parameters: paramInfo.allParams,
            requiredParameters: paramInfo.requiredParams,
            description: description,
          ));
          
          break;
        }
      }
    }
  }
  
  return modules;
}

/// 参数分析结果
class ParameterInfo {
  final List<String> allParams;
  final List<String> requiredParams;
  
  ParameterInfo({required this.allParams, required this.requiredParams});
}

/// 分析函数参数
ParameterInfo _analyzeFunctionParameters(String content, String functionName) {
  final allParams = <String>[];
  final requiredParams = <String>[];
  
  // 在内容中查找对query的访问模式
  final queryPattern = RegExp(r"query\['(\w+)'\]");
  final matches = queryPattern.allMatches(content);
  
  for (final match in matches) {
    final param = match.group(1)!;
    if (!allParams.contains(param)) {
      allParams.add(param);
      
      // 简单启发式判断：如果没有默认值或null检查，认为是必需的
      final startIndex = math.max(0, content.indexOf(match.group(0)!) - 50);
      final endIndex = math.min(content.length, content.indexOf(match.group(0)!) + 50);
      final paramUsage = content.substring(startIndex, endIndex);
      
      if (!paramUsage.contains('??') && !paramUsage.contains('!=')) {
        requiredParams.add(param);
      }
    }
  }
  
  // 确保cookie参数总是可选的
  if (!allParams.contains('cookie')) {
    allParams.add('cookie');
  }
  
  return ParameterInfo(allParams: allParams, requiredParams: requiredParams);
}

/// 生成增强的API常量文件
Future<void> _generateEnhancedApiConstantsFile(List<ModuleInfo> moduleInfos) async {
  final apiConstantsContent = '''// 自动生成的API常量文件
// 请勿手动编辑此文件，运行 auto_register_modules.dart 重新生成

/// API模块名称常量
/// 
/// 提供IDE智能提示和类型安全的模块名称
class ApiModules {
${moduleInfos.map((m) => "  /// ${m.description ?? m.name} 模块\n  static const String ${m.name} = '${m.name}';").join('\n')}
}

/// API参数帮助类
/// 
/// 为各个API模块提供参数构建方法，提供IDE智能提示
class ApiParams {
${moduleInfos.map((m) => _generateParamMethod(m)).join('\n')}
}

/// 类型安全的API调用包装器
/// 
/// 提供每个模块对应的参数提示和类型检查
class ApiCaller {
  final Future<Map<String, dynamic>> Function(String, Map<String, dynamic>) _call;
  
  const ApiCaller(this._call);
  
${moduleInfos.map((m) => _generateCallerMethod(m)).join('\n')}
}
''';

  final apiConstantsFile = File('lib/src/utils/api_constants.dart');
  await apiConstantsFile.writeAsString(apiConstantsContent);
  print('✅ 增强API常量文件已生成: ${apiConstantsFile.path}');
}

/// 生成参数方法
String _generateParamMethod(ModuleInfo module) {
  final paramList = module.parameters.map((param) {
    final isRequired = module.requiredParameters.contains(param);
    final type = _getParameterType(param);
    return isRequired ? 'required $type $param' : '$type? $param';
  }).toList();
  
  // 添加通用的timestamp参数
  paramList.add('String? timestamp');
  
  final paramMap = module.parameters.map((param) => "    '$param': $param,").toList();
  paramMap.add("    'timestamp': timestamp,");
  
  return '''  /// ${module.description ?? module.name} 参数
  static Map<String, dynamic> ${module.name}({
    ${paramList.join(', ')},
  }) => {
${paramMap.join('\n')}
  };''';
}

/// 生成调用方法
String _generateCallerMethod(ModuleInfo module) {
  final paramList = module.parameters.map((param) {
    final isRequired = module.requiredParameters.contains(param);
    final type = _getParameterType(param);
    return isRequired ? 'required $type $param' : '$type? $param';
  }).toList();
  
  // 添加通用的timestamp参数
  paramList.add('String? timestamp');
  
  final paramArgs = module.parameters.map((param) => '$param: $param').toList();
  paramArgs.add('timestamp: timestamp');
  
  return '''  /// ${module.description ?? module.name}
  Future<Map<String, dynamic>> ${module.name}({
    ${paramList.join(',\n    ')},
  }) => _call(ApiModules.${module.name}, ApiParams.${module.name}(
    ${paramArgs.join(',\n    ')},
  ));''';
}

/// 获取参数类型
String _getParameterType(String param) {
  // 根据参数名推断类型
  if (param.contains('limit') || param.contains('offset') || param.contains('type') || param.contains('count')) {
    return 'int';
  }
  return 'String';
}
