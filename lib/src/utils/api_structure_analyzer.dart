/// API响应数据结构分析工具
// ignore_for_file: prefer_conditional_assignment, unused_local_variable, dangling_library_doc_comments, unnecessary_brace_in_string_interps

class ApiStructureAnalyzer {
  /// 分析API响应的数据结构
  /// 
  /// 参数:
  /// - [apiResult] API请求的响应结果
  /// - [maxDepth] 最大分析深度，防止循环引用导致的无限递归，默认为5
  /// - [includeValues] 是否包含示例值，默认为true
  /// 
  /// 返回值:
  /// 返回一个描述数据结构的Map，包含类型信息和结构层次
  static Map<String, dynamic> analyzeStructure(
    dynamic apiResult, {
    int maxDepth = 5,
    bool includeValues = true,
  }) {
    return _analyzeValue(apiResult, 0, maxDepth, includeValues);
  }

  /// 生成数据结构的字符串描述
  /// 
  /// 参数:
  /// - [apiResult] API请求的响应结果
  /// - [maxDepth] 最大分析深度，默认为5
  /// - [includeValues] 是否包含示例值，默认为true
  /// - [indent] 缩进字符串，默认为两个空格
  /// 
  /// 返回值:
  /// 返回格式化的数据结构字符串
  static String generateStructureString(
    dynamic apiResult, {
    int maxDepth = 5,
    bool includeValues = true,
    String indent = '  ',
  }) {
    final structure = analyzeStructure(
      apiResult,
      maxDepth: maxDepth,
      includeValues: includeValues,
    );
    return _formatStructure(structure, 0, indent);
  }

  /// 生成TypeScript风格的接口定义
  /// 
  /// 参数:
  /// - [apiResult] API请求的响应结果
  /// - [interfaceName] 接口名称，默认为'ApiResponse'
  /// - [maxDepth] 最大分析深度，默认为5
  /// 
  /// 返回值:
  /// 返回TypeScript接口定义字符串
  static String generateTypeScriptInterface(
    dynamic apiResult, {
    String interfaceName = 'ApiResponse',
    int maxDepth = 5,
  }) {
    final structure = analyzeStructure(
      apiResult,
      maxDepth: maxDepth,
      includeValues: false,
    );
    return _generateTSInterface(structure, interfaceName, 0);
  }

  /// 生成Dart类定义
  /// 
  /// 参数:
  /// - [apiResult] API请求的响应结果
  /// - [className] 类名，默认为'ApiResponse'
  /// - [maxDepth] 最大分析深度，默认为5
  /// 
  /// 返回值:
  /// 返回Dart类定义字符串
  static String generateDartClass(
    dynamic apiResult, {
    String className = 'ApiResponse',
    int maxDepth = 5,
  }) {
    final structure = analyzeStructure(
      apiResult,
      maxDepth: maxDepth,
      includeValues: false,
    );
    return _generateDartClass(structure, className, 0);
  }

  /// 递归分析值的结构
  static Map<String, dynamic> _analyzeValue(
    dynamic value,
    int currentDepth,
    int maxDepth,
    bool includeValues,
  ) {
    if (currentDepth >= maxDepth) {
      return {
        'type': 'max_depth_reached',
        'description': '达到最大分析深度',
      };
    }

    if (value == null) {
      return {
        'type': 'null',
        'nullable': true,
        if (includeValues) 'example': null,
      };
    }

    if (value is bool) {
      return {
        'type': 'boolean',
        'nullable': false,
        if (includeValues) 'example': value,
      };
    }

    if (value is int) {
      return {
        'type': 'integer',
        'nullable': false,
        if (includeValues) 'example': value,
      };
    }

    if (value is double) {
      return {
        'type': 'double',
        'nullable': false,
        if (includeValues) 'example': value,
      };
    }

    if (value is String) {
      return {
        'type': 'string',
        'nullable': false,
        'length': value.length,
        if (includeValues) 'example': value.length > 50 
            ? '${value.substring(0, 47)}...' 
            : value,
      };
    }

    if (value is List) {
      if (value.isEmpty) {
        return {
          'type': 'array',
          'nullable': false,
          'length': 0,
          'items': {
            'type': 'unknown',
            'description': '空数组，无法确定元素类型',
          },
        };
      }

      // 分析数组中的元素类型
      final itemTypes = <String, int>{};
      Map<String, dynamic>? firstItemStructure;

      for (int i = 0; i < value.length && i < 10; i++) {  // 最多分析前10个元素
        final itemStructure = _analyzeValue(
          value[i],
          currentDepth + 1,
          maxDepth,
          false,
        );
        final itemType = itemStructure['type'] as String;
        itemTypes[itemType] = (itemTypes[itemType] ?? 0) + 1;
        
        if (firstItemStructure == null) {
          firstItemStructure = itemStructure;
        }
      }

      return {
        'type': 'array',
        'nullable': false,
        'length': value.length,
        'items': firstItemStructure ?? {'type': 'unknown'},
        'item_types': itemTypes,
        if (includeValues && value.isNotEmpty) 
          'example': [_analyzeValue(value[0], currentDepth + 1, maxDepth, true)],
      };
    }

    if (value is Map) {
      final properties = <String, dynamic>{};
      final requiredFields = <String>[];

      for (final entry in value.entries) {
        final key = entry.key.toString();
        final fieldStructure = _analyzeValue(
          entry.value,
          currentDepth + 1,
          maxDepth,
          includeValues,
        );
        
        properties[key] = fieldStructure;
        
        // 如果字段值不为null，认为是必需字段
        if (entry.value != null) {
          requiredFields.add(key);
        }
      }

      return {
        'type': 'object',
        'nullable': false,
        'properties': properties,
        'required_fields': requiredFields,
        'field_count': value.length,
      };
    }

    // 其他类型
    return {
      'type': value.runtimeType.toString(),
      'nullable': false,
      'description': '未知类型: ${value.runtimeType}',
      if (includeValues) 'example': value.toString(),
    };
  }

  /// 格式化结构为字符串
  static String _formatStructure(
    Map<String, dynamic> structure,
    int depth,
    String indent,
  ) {
    final indentStr = indent * depth;
    final type = structure['type'] as String;
    final buffer = StringBuffer();

    switch (type) {
      case 'object':
        buffer.writeln('${indentStr}Object {');
        final properties = structure['properties'] as Map<String, dynamic>;
        final requiredFields = structure['required_fields'] as List<dynamic>;
        
        for (final entry in properties.entries) {
          final isRequired = requiredFields.contains(entry.key);
          final requiredMark = isRequired ? '' : '?';
          buffer.write('${indentStr}$indent${entry.key}$requiredMark: ');
          
          final fieldStructure = entry.value as Map<String, dynamic>;
          final fieldType = fieldStructure['type'] as String;
          
          if (fieldType == 'object' || fieldType == 'array') {
            buffer.writeln('');
            buffer.write(_formatStructure(fieldStructure, depth + 1, indent));
          } else {
            buffer.write(_formatSimpleType(fieldStructure));
            buffer.writeln('');
          }
        }
        buffer.write('${indentStr}}');
        break;
        
      case 'array':
        final items = structure['items'] as Map<String, dynamic>;
        final length = structure['length'] as int;
        buffer.write('${indentStr}Array[$length] of ');
        
        if (items['type'] == 'object' || items['type'] == 'array') {
          buffer.writeln('');
          buffer.write(_formatStructure(items, depth + 1, indent));
        } else {
          buffer.write(_formatSimpleType(items));
        }
        break;
        
      default:
        buffer.write('${indentStr}${_formatSimpleType(structure)}');
    }

    return buffer.toString();
  }

  /// 格式化简单类型
  static String _formatSimpleType(Map<String, dynamic> structure) {
    final type = structure['type'] as String;
    final nullable = structure['nullable'] as bool? ?? false;
    final nullableMark = nullable ? '?' : '';
    
    switch (type) {
      case 'string':
        final length = structure['length'] as int?;
        // final lengthInfo = length != null ? ' (长度: $length)' : '';
        return 'String$nullableMark';
        
      case 'integer':
        return 'int$nullableMark';
        
      case 'double':
        return 'double$nullableMark';
        
      case 'boolean':
        return 'bool$nullableMark';
        
      case 'null':
        return 'null';
        
      default:
        return '$type$nullableMark';
    }
  }

  /// 生成TypeScript接口
  static String _generateTSInterface(
    Map<String, dynamic> structure,
    String interfaceName,
    int depth,
  ) {
    final indentStr = '  ' * depth;
    final buffer = StringBuffer();
    
    if (structure['type'] == 'object') {
      buffer.writeln('${indentStr}interface $interfaceName {');
      
      final properties = structure['properties'] as Map<String, dynamic>;
      final requiredFields = structure['required_fields'] as List<dynamic>;
      
      for (final entry in properties.entries) {
        final isRequired = requiredFields.contains(entry.key);
        final optionalMark = isRequired ? '' : '?';
        final fieldStructure = entry.value as Map<String, dynamic>;
        final tsType = _toTypeScriptType(fieldStructure);
        
        buffer.writeln('${indentStr}  ${entry.key}$optionalMark: $tsType;');
      }
      
      buffer.write('${indentStr}}');
    }
    
    return buffer.toString();
  }

  /// 生成Dart类
  static String _generateDartClass(
    Map<String, dynamic> structure,
    String className,
    int depth,
  ) {
    final indentStr = '  ' * depth;
    final buffer = StringBuffer();
    
    if (structure['type'] == 'object') {
      buffer.writeln('${indentStr}class $className {');
      
      final properties = structure['properties'] as Map<String, dynamic>;
      final requiredFields = structure['required_fields'] as List<dynamic>;
      
      // 生成字段
      for (final entry in properties.entries) {
        final isRequired = requiredFields.contains(entry.key);
        final fieldStructure = entry.value as Map<String, dynamic>;
        final dartType = _toDartType(fieldStructure, !isRequired);
        
        buffer.writeln('${indentStr}  final $dartType ${entry.key};');
      }
      
      buffer.writeln('');
      
      // 生成构造函数
      buffer.writeln('${indentStr}  $className({');
      for (final entry in properties.entries) {
        final isRequired = requiredFields.contains(entry.key);
        final requiredKeyword = isRequired ? 'required ' : '';
        buffer.writeln('${indentStr}    ${requiredKeyword}this.${entry.key},');
      }
      buffer.writeln('${indentStr}  });');
      
      buffer.write('${indentStr}}');
    }
    
    return buffer.toString();
  }

  /// 转换为TypeScript类型
  static String _toTypeScriptType(Map<String, dynamic> structure) {
    final type = structure['type'] as String;
    final nullable = structure['nullable'] as bool? ?? false;
    
    String baseType;
    switch (type) {
      case 'string':
        baseType = 'string';
        break;
      case 'integer':
      case 'double':
        baseType = 'number';
        break;
      case 'boolean':
        baseType = 'boolean';
        break;
      case 'array':
        final items = structure['items'] as Map<String, dynamic>;
        final itemType = _toTypeScriptType(items);
        baseType = '$itemType[]';
        break;
      case 'object':
        baseType = 'object';
        break;
      case 'null':
        return 'null';
      default:
        baseType = 'any';
    }
    
    return nullable ? '$baseType | null' : baseType;
  }

  /// 转换为Dart类型
  static String _toDartType(Map<String, dynamic> structure, bool nullable) {
    final type = structure['type'] as String;
    final nullableMark = nullable ? '?' : '';
    
    switch (type) {
      case 'string':
        return 'String$nullableMark';
      case 'integer':
        return 'int$nullableMark';
      case 'double':
        return 'double$nullableMark';
      case 'boolean':
        return 'bool$nullableMark';
      case 'array':
        final items = structure['items'] as Map<String, dynamic>;
        final itemType = _toDartType(items, false);
        return 'List<$itemType>$nullableMark';
      case 'object':
        return 'Map<String, dynamic>$nullableMark';
      case 'null':
        return 'dynamic';
      default:
        return 'dynamic$nullableMark';
    }
  }

  /// 获取结构统计信息
  static Map<String, dynamic> getStatistics(dynamic apiResult) {
    final structure = analyzeStructure(apiResult, includeValues: false);
    return _collectStatistics(structure);
  }

  /// 收集统计信息
  static Map<String, dynamic> _collectStatistics(Map<String, dynamic> structure) {
    final stats = <String, dynamic>{
      'total_fields': 0,
      'type_distribution': <String, int>{},
      'max_depth': 0,
      'nullable_fields': 0,
      'array_count': 0,
      'object_count': 0,
    };

    _countFields(structure, stats, 0);
    return stats;
  }

  /// 递归统计字段
  static void _countFields(
    Map<String, dynamic> structure,
    Map<String, dynamic> stats,
    int depth,
  ) {
    final type = structure['type'] as String;
    final nullable = structure['nullable'] as bool? ?? false;
    
    // 更新最大深度
    if (depth > stats['max_depth']) {
      stats['max_depth'] = depth;
    }
    
    // 统计类型分布
    final typeDistribution = stats['type_distribution'] as Map<String, int>;
    typeDistribution[type] = (typeDistribution[type] ?? 0) + 1;
    
    // 统计可空字段
    if (nullable) {
      stats['nullable_fields'] = (stats['nullable_fields'] as int) + 1;
    }
    
    switch (type) {
      case 'object':
        stats['object_count'] = (stats['object_count'] as int) + 1;
        final properties = structure['properties'] as Map<String, dynamic>;
        stats['total_fields'] = (stats['total_fields'] as int) + properties.length;
        
        for (final property in properties.values) {
          _countFields(property as Map<String, dynamic>, stats, depth + 1);
        }
        break;
        
      case 'array':
        stats['array_count'] = (stats['array_count'] as int) + 1;
        final items = structure['items'] as Map<String, dynamic>;
        _countFields(items, stats, depth + 1);
        break;
        
      default:
        stats['total_fields'] = (stats['total_fields'] as int) + 1;
    }
  }
}
