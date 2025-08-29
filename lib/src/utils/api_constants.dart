// 自动生成的API常量文件
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
  /// 返回专辑详细信息，包括歌曲列表、专辑信息等 模块
  static const String album = 'album';
  /// 返回专辑的动态信息，如播放量、评论数、分享数等 模块
  static const String albumDetailDynamic = 'albumDetailDynamic';
  /// 返回用户已收藏的专辑列表 模块
  static const String albumSublist = 'albumSublist';
  /// 返回手机端专辑详情信息，包含专辑的详细信息和歌曲列表 模块
  static const String apiAlbumV3Detail = 'apiAlbumV3Detail';
  /// 二维码登录检测 模块
  static const String loginQrCheck = 'loginQrCheck';
  /// 二维码登录创建 模块
  static const String loginQrCreate = 'loginQrCreate';
  /// 二维码登录 key 生成 模块
  static const String loginQrKey = 'loginQrKey';
  /// 登录刷新 模块
  static const String loginRefresh = 'loginRefresh';
  /// 登录状态 模块
  static const String loginStatus = 'loginStatus';
  /// 退出登录 模块
  static const String logout = 'logout';
  /// 推荐歌单 模块
  static const String personalized = 'personalized';
  /// 歌单详情 模块
  static const String playlistDetail = 'playlistDetail';
  /// 例如: /playlist/track/all?id=7044354223&limit=10 模块
  static const String playlistTrackAll = 'playlistTrackAll';
  /// 每日推荐歌单 模块
  static const String recommendResource = 'recommendResource';
  /// 每日推荐歌曲 模块
  static const String recommendSongs = 'recommendSongs';
  /// 搜索 模块
  static const String search = 'search';
  /// 歌曲详情 模块
  static const String songDetail = 'songDetail';
  /// 而是采用 standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带) 进行音质判断 模块
  static const String songUrlV1 = 'songUrlV1';
  /// 音乐百科基础信息 模块
  static const String songWikiSummary = 'songWikiSummary';
  /// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等 模块
  static const String userAccount = 'userAccount';
  /// 用户详情 模块
  static const String userDetail = 'userDetail';
  /// 用户歌单 模块
  static const String userPlaylist = 'userPlaylist';
  /// 用户听歌记录 模块
  static const String userRecord = 'userRecord';
}

/// API模块信息常量
/// 
/// 提供每个API模块的参数信息
class ApiInfo {
  /// 返回专辑详细信息，包括歌曲列表、专辑信息等 参数信息
  static Map<String, ParameterInfo> album() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 返回专辑的动态信息，如播放量、评论数、分享数等 参数信息
  static Map<String, ParameterInfo> albumDetailDynamic() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 返回用户已收藏的专辑列表 参数信息
  static Map<String, ParameterInfo> albumSublist() {
    return {
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 返回手机端专辑详情信息，包含专辑的详细信息和歌曲列表 参数信息
  static Map<String, ParameterInfo> apiAlbumV3Detail() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      'er': ParameterInfo(name: 'er', isRequired: false, type: 'String', description: 'er参数'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 二维码登录检测 参数信息
  static Map<String, ParameterInfo> loginQrCheck() {
    return {
      'key': ParameterInfo(name: 'key', isRequired: true, type: 'String', description: '密钥'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 二维码登录创建 参数信息
  static Map<String, ParameterInfo> loginQrCreate() {
    return {
      'key': ParameterInfo(name: 'key', isRequired: true, type: 'String', description: '密钥'),
      'qrimg': ParameterInfo(name: 'qrimg', isRequired: true, type: 'String', description: '是否返回二维码图片'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 二维码登录 key 生成 参数信息
  static Map<String, ParameterInfo> loginQrKey() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 登录刷新 参数信息
  static Map<String, ParameterInfo> loginRefresh() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 登录状态 参数信息
  static Map<String, ParameterInfo> loginStatus() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 退出登录 参数信息
  static Map<String, ParameterInfo> logout() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 推荐歌单 参数信息
  static Map<String, ParameterInfo> personalized() {
    return {
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 歌单详情 参数信息
  static Map<String, ParameterInfo> playlistDetail() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      's': ParameterInfo(name: 's', isRequired: false, type: 'String', description: '额外参数'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 例如: /playlist/track/all?id=7044354223&limit=10 参数信息
  static Map<String, ParameterInfo> playlistTrackAll() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      's': ParameterInfo(name: 's', isRequired: false, type: 'String', description: '额外参数'),
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 每日推荐歌单 参数信息
  static Map<String, ParameterInfo> recommendResource() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 每日推荐歌曲 参数信息
  static Map<String, ParameterInfo> recommendSongs() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 搜索 参数信息
  static Map<String, ParameterInfo> search() {
    return {
      'type': ParameterInfo(name: 'type', isRequired: false, type: 'int', description: '类型'),
      'keywords': ParameterInfo(name: 'keywords', isRequired: true, type: 'String', description: '搜索关键词'),
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 歌曲详情 参数信息
  static Map<String, ParameterInfo> songDetail() {
    return {
      'ids': ParameterInfo(name: 'ids', isRequired: true, type: 'String', description: 'ID列表，多个用逗号分隔'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 而是采用 standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带) 进行音质判断 参数信息
  static Map<String, ParameterInfo> songUrlV1() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      'level': ParameterInfo(name: 'level', isRequired: true, type: 'String', description: '音质等级'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 音乐百科基础信息 参数信息
  static Map<String, ParameterInfo> songWikiSummary() {
    return {
      'id': ParameterInfo(name: 'id', isRequired: true, type: 'String', description: 'ID'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等 参数信息
  static Map<String, ParameterInfo> userAccount() {
    return {
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 用户详情 参数信息
  static Map<String, ParameterInfo> userDetail() {
    return {
      'uid': ParameterInfo(name: 'uid', isRequired: true, type: 'String', description: '用户ID'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 用户歌单 参数信息
  static Map<String, ParameterInfo> userPlaylist() {
    return {
      'uid': ParameterInfo(name: 'uid', isRequired: false, type: 'String', description: '用户ID'),
      'limit': ParameterInfo(name: 'limit', isRequired: false, type: 'int', description: '限制返回数量'),
      'offset': ParameterInfo(name: 'offset', isRequired: false, type: 'int', description: '偏移量'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }
  /// 用户听歌记录 参数信息
  static Map<String, ParameterInfo> userRecord() {
    return {
      'uid': ParameterInfo(name: 'uid', isRequired: false, type: 'String', description: '用户ID'),
      'type': ParameterInfo(name: 'type', isRequired: false, type: 'int', description: '类型'),
      'cookie': ParameterInfo(name: 'cookie', isRequired: false, type: 'String', description: 'cookie字符串'),
      'timestamp': ParameterInfo(name: 'timestamp', isRequired: false, type: 'String', description: '时间戳'),
    };
  }

  /// 获取所有API信息
  static Map<String, Map<String, ParameterInfo>> getAllApiInfo() {
    return {
      'album': album(),
      'albumDetailDynamic': albumDetailDynamic(),
      'albumSublist': albumSublist(),
      'apiAlbumV3Detail': apiAlbumV3Detail(),
      'loginQrCheck': loginQrCheck(),
      'loginQrCreate': loginQrCreate(),
      'loginQrKey': loginQrKey(),
      'loginRefresh': loginRefresh(),
      'loginStatus': loginStatus(),
      'logout': logout(),
      'personalized': personalized(),
      'playlistDetail': playlistDetail(),
      'playlistTrackAll': playlistTrackAll(),
      'recommendResource': recommendResource(),
      'recommendSongs': recommendSongs(),
      'search': search(),
      'songDetail': songDetail(),
      'songUrlV1': songUrlV1(),
      'songWikiSummary': songWikiSummary(),
      'userAccount': userAccount(),
      'userDetail': userDetail(),
      'userPlaylist': userPlaylist(),
      'userRecord': userRecord(),
    };
  }
}

/// API参数帮助类
/// 
/// 为各个API模块提供参数构建方法，提供IDE智能提示
class ApiParams {
  /// 返回专辑详细信息，包括歌曲列表、专辑信息等 参数
  static Map<String, dynamic> album({
    required String id, String? cookie, String? timestamp,
  }) => {
    'id': id,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 返回专辑的动态信息，如播放量、评论数、分享数等 参数
  static Map<String, dynamic> albumDetailDynamic({
    required String id, String? cookie, String? timestamp,
  }) => {
    'id': id,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 返回用户已收藏的专辑列表 参数
  static Map<String, dynamic> albumSublist({
    int? limit, int? offset, String? cookie, String? timestamp,
  }) => {
    'limit': limit,
    'offset': offset,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 返回手机端专辑详情信息，包含专辑的详细信息和歌曲列表 参数
  static Map<String, dynamic> apiAlbumV3Detail({
    required String id, String? er, String? cookie, String? timestamp,
  }) => {
    'id': id,
    'er': er,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 二维码登录检测 参数
  static Map<String, dynamic> loginQrCheck({
    required String key, String? cookie, String? timestamp,
  }) => {
    'key': key,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 二维码登录创建 参数
  static Map<String, dynamic> loginQrCreate({
    required String key, required String qrimg, String? cookie, String? timestamp,
  }) => {
    'key': key,
    'qrimg': qrimg,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 二维码登录 key 生成 参数
  static Map<String, dynamic> loginQrKey({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 登录刷新 参数
  static Map<String, dynamic> loginRefresh({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 登录状态 参数
  static Map<String, dynamic> loginStatus({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 退出登录 参数
  static Map<String, dynamic> logout({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 推荐歌单 参数
  static Map<String, dynamic> personalized({
    int? limit, String? cookie, String? timestamp,
  }) => {
    'limit': limit,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 歌单详情 参数
  static Map<String, dynamic> playlistDetail({
    required String id, String? s, String? cookie, String? timestamp,
  }) => {
    'id': id,
    's': s,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 例如: /playlist/track/all?id=7044354223&limit=10 参数
  static Map<String, dynamic> playlistTrackAll({
    required String id, String? s, int? limit, int? offset, String? cookie, String? timestamp,
  }) => {
    'id': id,
    's': s,
    'limit': limit,
    'offset': offset,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 每日推荐歌单 参数
  static Map<String, dynamic> recommendResource({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 每日推荐歌曲 参数
  static Map<String, dynamic> recommendSongs({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 搜索 参数
  static Map<String, dynamic> search({
    int? type, required String keywords, int? limit, int? offset, String? cookie, String? timestamp,
  }) => {
    'type': type,
    'keywords': keywords,
    'limit': limit,
    'offset': offset,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 歌曲详情 参数
  static Map<String, dynamic> songDetail({
    required String ids, String? cookie, String? timestamp,
  }) => {
    'ids': ids,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 而是采用 standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带) 进行音质判断 参数
  static Map<String, dynamic> songUrlV1({
    required String id, required String level, String? cookie, String? timestamp,
  }) => {
    'id': id,
    'level': level,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 音乐百科基础信息 参数
  static Map<String, dynamic> songWikiSummary({
    required String id, String? cookie, String? timestamp,
  }) => {
    'id': id,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等 参数
  static Map<String, dynamic> userAccount({
    String? cookie, String? timestamp,
  }) => {
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 用户详情 参数
  static Map<String, dynamic> userDetail({
    required String uid, String? cookie, String? timestamp,
  }) => {
    'uid': uid,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 用户歌单 参数
  static Map<String, dynamic> userPlaylist({
    String? uid, int? limit, int? offset, String? cookie, String? timestamp,
  }) => {
    'uid': uid,
    'limit': limit,
    'offset': offset,
    'cookie': cookie,
    'timestamp': timestamp,
  };
  /// 用户听歌记录 参数
  static Map<String, dynamic> userRecord({
    String? uid, int? type, String? cookie, String? timestamp,
  }) => {
    'uid': uid,
    'type': type,
    'cookie': cookie,
    'timestamp': timestamp,
  };
}

/// 类型安全的API调用包装器
/// 
/// 提供每个模块对应的参数提示和类型检查
class ApiCaller {
  final Future<Map<String, dynamic>> Function(String, Map<String, dynamic>) _call;
  
  const ApiCaller(this._call);
  
  /// 返回专辑详细信息，包括歌曲列表、专辑信息等
  Future<Map<String, dynamic>> album({
    required String id,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.album, ApiParams.album(
    id: id,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 返回专辑的动态信息，如播放量、评论数、分享数等
  Future<Map<String, dynamic>> albumDetailDynamic({
    required String id,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.albumDetailDynamic, ApiParams.albumDetailDynamic(
    id: id,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 返回用户已收藏的专辑列表
  Future<Map<String, dynamic>> albumSublist({
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.albumSublist, ApiParams.albumSublist(
    limit: limit,
    offset: offset,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 返回手机端专辑详情信息，包含专辑的详细信息和歌曲列表
  Future<Map<String, dynamic>> apiAlbumV3Detail({
    required String id,
    String? er,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.apiAlbumV3Detail, ApiParams.apiAlbumV3Detail(
    id: id,
    er: er,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 二维码登录检测
  Future<Map<String, dynamic>> loginQrCheck({
    required String key,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.loginQrCheck, ApiParams.loginQrCheck(
    key: key,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 二维码登录创建
  Future<Map<String, dynamic>> loginQrCreate({
    required String key,
    required String qrimg,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.loginQrCreate, ApiParams.loginQrCreate(
    key: key,
    qrimg: qrimg,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 二维码登录 key 生成
  Future<Map<String, dynamic>> loginQrKey({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.loginQrKey, ApiParams.loginQrKey(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 登录刷新
  Future<Map<String, dynamic>> loginRefresh({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.loginRefresh, ApiParams.loginRefresh(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 登录状态
  Future<Map<String, dynamic>> loginStatus({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.loginStatus, ApiParams.loginStatus(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 退出登录
  Future<Map<String, dynamic>> logout({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.logout, ApiParams.logout(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 推荐歌单
  Future<Map<String, dynamic>> personalized({
    int? limit,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.personalized, ApiParams.personalized(
    limit: limit,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 歌单详情
  Future<Map<String, dynamic>> playlistDetail({
    required String id,
    String? s,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.playlistDetail, ApiParams.playlistDetail(
    id: id,
    s: s,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 例如: /playlist/track/all?id=7044354223&limit=10
  Future<Map<String, dynamic>> playlistTrackAll({
    required String id,
    String? s,
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.playlistTrackAll, ApiParams.playlistTrackAll(
    id: id,
    s: s,
    limit: limit,
    offset: offset,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 每日推荐歌单
  Future<Map<String, dynamic>> recommendResource({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.recommendResource, ApiParams.recommendResource(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 每日推荐歌曲
  Future<Map<String, dynamic>> recommendSongs({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.recommendSongs, ApiParams.recommendSongs(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 搜索
  Future<Map<String, dynamic>> search({
    int? type,
    required String keywords,
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.search, ApiParams.search(
    type: type,
    keywords: keywords,
    limit: limit,
    offset: offset,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 歌曲详情
  Future<Map<String, dynamic>> songDetail({
    required String ids,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.songDetail, ApiParams.songDetail(
    ids: ids,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 而是采用 standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带) 进行音质判断
  Future<Map<String, dynamic>> songUrlV1({
    required String id,
    required String level,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.songUrlV1, ApiParams.songUrlV1(
    id: id,
    level: level,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 音乐百科基础信息
  Future<Map<String, dynamic>> songWikiSummary({
    required String id,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.songWikiSummary, ApiParams.songWikiSummary(
    id: id,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等
  Future<Map<String, dynamic>> userAccount({
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.userAccount, ApiParams.userAccount(
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 用户详情
  Future<Map<String, dynamic>> userDetail({
    required String uid,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.userDetail, ApiParams.userDetail(
    uid: uid,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 用户歌单
  Future<Map<String, dynamic>> userPlaylist({
    String? uid,
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.userPlaylist, ApiParams.userPlaylist(
    uid: uid,
    limit: limit,
    offset: offset,
    cookie: cookie,
    timestamp: timestamp,
  ));
  /// 用户听歌记录
  Future<Map<String, dynamic>> userRecord({
    String? uid,
    int? type,
    String? cookie,
    String? timestamp,
  }) => _call(ApiModules.userRecord, ApiParams.userRecord(
    uid: uid,
    type: type,
    cookie: cookie,
    timestamp: timestamp,
  ));
}
