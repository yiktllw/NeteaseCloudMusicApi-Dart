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
  final processedModules = <String>{};  // 添加去重集合

  await for (final entity in modulesDir.list()) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final fileName = entity.path.split('/').last.split('\\').last;
      if (fileName != '.DS_Store' && !moduleFiles.contains(fileName)) {  // 防止重复处理
        moduleFiles.add(fileName);
        print('发现模块文件: $fileName');

        // 读取文件内容分析函数和参数
        final content = await entity.readAsString();
        final modules = _extractModuleInfo(content, fileName);

        for (final module in modules) {
          // 防止重复注册同名模块
          if (!processedModules.contains(module.name)) {
            moduleInfos.add(module);
            processedModules.add(module.name);
            print('  - 发现函数: ${module.name}');
            print('    参数: ${module.parameters.join(', ')}');
            if (module.requiredParameters.isNotEmpty) {
              print('    必需参数: ${module.requiredParameters.join(', ')}');
            }
          } else {
            print('  - 跳过重复函数: ${module.name}');
          }
        }

        if (!imports.contains("import '../modules/$fileName';")) {  // 防止重复导入
          imports.add("import '../modules/$fileName';");
        }
      }
    }
  }

  // 生成注册代码
  print('\n=== 生成注册代码 ===');

  // 为每个模块生成注册调用
  for (final module in moduleInfos) {
    final registrationCall =
        "    ModuleRegistry.register('${module.name}', ${module.name});";
    registrations.add(registrationCall);
  }

  // 生成完整的中间文件
  await _generateAutoRegisterFile(
      imports, registrations, moduleInfos.map((m) => m.name).toList());

  // 生成增强的API常量文件
  await _generateEnhancedApiConstantsFile(moduleInfos);

  print('\n✅ 自动注册完成！');
  print('发现 ${moduleFiles.length} 个模块文件');
  print('注册 ${moduleInfos.length} 个API函数');
  print('生成的中间文件: lib/src/utils/auto_register.dart');
  print('生成的增强API常量文件: lib/src/utils/api_constants.dart');
}

/// 生成自动注册中间文件
Future<void> _generateAutoRegisterFile(List<String> imports,
    List<String> registrations, List<String> moduleNames) async {
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
      final endIndex =
          math.min(content.length, content.indexOf(match.group(0)!) + 50);
      final paramUsage = content.substring(startIndex, endIndex);

      if (!paramUsage.contains('??') && !paramUsage.contains('!=')) {
        requiredParams.add(param);
      }
    }
  }

  // 确保cookie和timestamp参数总是存在且可选
  if (!allParams.contains('cookie')) {
    allParams.add('cookie');
  }
  if (!allParams.contains('timestamp')) {
    allParams.add('timestamp');
  }
  
  // 确保cookie和timestamp不在必需参数列表中
  requiredParams.remove('cookie');
  requiredParams.remove('timestamp');

  return ParameterInfo(allParams: allParams, requiredParams: requiredParams);
}

/// 生成增强的API常量文件
Future<void> _generateEnhancedApiConstantsFile(
    List<ModuleInfo> moduleInfos) async {
  final apiConstantsContent = '''// 自动生成的API常量文件
// 请勿手动编辑此文件，运行 auto_register_modules.dart 重新生成

/// 参数信息类
class ParameterInfo {
  final String name;
  final bool isRequired;
  final String type;
  final String description;

  const ParameterInfo({
    required this.name,
    required this.isRequired,
    required this.type,
    required this.description,
  });
}

/// API模块名称常量
/// 
/// 提供IDE智能提示和类型安全的模块名称
class ApiModules {
${moduleInfos.map((m) => "  /// ${m.description ?? m.name} 模块\n  static const String ${m.name} = '${m.name}';").join('\n')}
}

/// API模块信息常量
/// 
/// 提供每个API模块的参数信息
class ApiInfo {
${moduleInfos.map((m) => _generateApiInfoMethod(m)).join('\n')}

  /// 获取所有API信息
  static Map<String, Map<String, ParameterInfo>> getAllApiInfo() {
    return {
${moduleInfos.map((m) => "      '${m.name}': ${m.name}(),").join('\n')}
    };
  }
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

/// 生成API信息方法
String _generateApiInfoMethod(ModuleInfo module) {
  final allParams = <String>[...module.parameters];
  
  // 确保cookie和timestamp参数存在且不重复
  if (!allParams.contains('cookie')) {
    allParams.add('cookie');
  }
  if (!allParams.contains('timestamp')) {
    allParams.add('timestamp');
  }
  
  final paramInfos = allParams.map((param) {
    final isRequired = module.requiredParameters.contains(param);
    final type = _getParameterType(param);
    final description = _getParameterDescription(param, module.name);
    return "      '$param': ParameterInfo(name: '$param', isRequired: $isRequired, type: '$type', description: '$description'),";
  }).toList();

  return '''  /// ${module.description ?? module.name} 参数信息
  static Map<String, ParameterInfo> ${module.name}() {
    return {
${paramInfos.join('\n')}
    };
  }''';
}

/// 获取参数描述
String _getParameterDescription(String param, String moduleName) {
  // 根据参数名推断描述
  final descriptions = {
    'cookie': 'cookie字符串',
    'timestamp': '时间戳',
    'limit': '限制返回数量',
    'offset': '偏移量',
    'id': 'ID',
    'uid': '用户ID',
    'type': '类型',
    'keywords': '搜索关键词',
    'key': '密钥',
    'qrimg': '是否返回二维码图片',
    's': '额外参数',
    'ids': 'ID列表，多个用逗号分隔',
    'level': '音质等级',
  };
  
  return descriptions[param] ?? '$param参数';
}

/// 生成参数方法
String _generateParamMethod(ModuleInfo module) {
  final allParams = <String>[...module.parameters];
  
  // 确保cookie和timestamp参数存在且不重复
  if (!allParams.contains('cookie')) {
    allParams.add('cookie');
  }
  if (!allParams.contains('timestamp')) {
    allParams.add('timestamp');
  }
  
  final paramList = allParams.map((param) {
    final isRequired = module.requiredParameters.contains(param);
    final type = _getParameterType(param);
    return isRequired ? 'required $type $param' : '$type? $param';
  }).toList();

  final paramMap = allParams.map((param) => "    '$param': $param,").toList();

  return '''  /// ${module.description ?? module.name} 参数
  static Map<String, dynamic> ${module.name}({
    ${paramList.join(', ')},
  }) => {
${paramMap.join('\n')}
  };''';
}

/// 生成调用方法
String _generateCallerMethod(ModuleInfo module) {
  final allParams = <String>[...module.parameters];
  
  // 确保cookie和timestamp参数存在且不重复
  if (!allParams.contains('cookie')) {
    allParams.add('cookie');
  }
  if (!allParams.contains('timestamp')) {
    allParams.add('timestamp');
  }
  
  final paramList = allParams.map((param) {
    final isRequired = module.requiredParameters.contains(param);
    final type = _getParameterType(param);
    return isRequired ? 'required $type $param' : '$type? $param';
  }).toList();

  final paramArgs = allParams.map((param) => '$param: $param').toList();

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
  if (param.contains('limit') ||
      param.contains('offset') ||
      param.contains('type') ||
      param.contains('count')) {
    return 'int';
  }
  return 'String';
}
