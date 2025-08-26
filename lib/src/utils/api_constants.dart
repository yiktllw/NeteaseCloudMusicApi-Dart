// 自动生成的API常量文件
// 请勿手动编辑此文件，运行 auto_register_modules.dart 重新生成

/// API模块名称常量
///
/// 提供IDE智能提示和类型安全的模块名称
class ApiModules {
  /// 返回用户已收藏的专辑列表 模块
  static const String albumSublist = 'albumSublist';

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

/// API参数帮助类
///
/// 为各个API模块提供参数构建方法，提供IDE智能提示
class ApiParams {
  /// 返回用户已收藏的专辑列表 参数
  static Map<String, dynamic> albumSublist({
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'limit': limit,
        'offset': offset,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 二维码登录检测 参数
  static Map<String, dynamic> loginQrCheck({
    required String key,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'key': key,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 二维码登录创建 参数
  static Map<String, dynamic> loginQrCreate({
    required String key,
    required String qrimg,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'key': key,
        'qrimg': qrimg,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 二维码登录 key 生成 参数
  static Map<String, dynamic> loginQrKey({
    String? cookie,
    String? timestamp,
  }) =>
      {
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 登录刷新 参数
  static Map<String, dynamic> loginRefresh({
    String? cookie,
    String? timestamp,
  }) =>
      {
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 登录状态 参数
  static Map<String, dynamic> loginStatus({
    String? cookie,
    String? timestamp,
  }) =>
      {
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 退出登录 参数
  static Map<String, dynamic> logout({
    String? cookie,
    String? timestamp,
  }) =>
      {
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 推荐歌单 参数
  static Map<String, dynamic> personalized({
    int? limit,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'limit': limit,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 歌单详情 参数
  static Map<String, dynamic> playlistDetail({
    required String id,
    String? s,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'id': id,
        's': s,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 例如: /playlist/track/all?id=7044354223&limit=10 参数
  static Map<String, dynamic> playlistTrackAll({
    required String id,
    String? s,
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'id': id,
        's': s,
        'limit': limit,
        'offset': offset,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 每日推荐歌曲 参数
  static Map<String, dynamic> recommendSongs({
    String? cookie,
    String? timestamp,
  }) =>
      {
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 搜索 参数
  static Map<String, dynamic> search({
    int? type,
    required String keywords,
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'type': type,
        'keywords': keywords,
        'limit': limit,
        'offset': offset,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 歌曲详情 参数
  static Map<String, dynamic> songDetail({
    required String ids,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'ids': ids,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 而是采用 standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带) 进行音质判断 参数
  static Map<String, dynamic> songUrlV1({
    required String id,
    required String level,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'id': id,
        'level': level,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 音乐百科基础信息 参数
  static Map<String, dynamic> songWikiSummary({
    required String id,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'id': id,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等 参数
  static Map<String, dynamic> userAccount({
    String? cookie,
    String? timestamp,
  }) =>
      {
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 用户详情 参数
  static Map<String, dynamic> userDetail({
    required String uid,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'uid': uid,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 用户歌单 参数
  static Map<String, dynamic> userPlaylist({
    String? uid,
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) =>
      {
        'uid': uid,
        'limit': limit,
        'offset': offset,
        'cookie': cookie,
        'timestamp': timestamp,
      };

  /// 用户听歌记录 参数
  static Map<String, dynamic> userRecord({
    String? uid,
    int? type,
    String? cookie,
    String? timestamp,
  }) =>
      {
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
  final Future<Map<String, dynamic>> Function(String, Map<String, dynamic>)
      _call;

  const ApiCaller(this._call);

  /// 返回用户已收藏的专辑列表
  Future<Map<String, dynamic>> albumSublist({
    int? limit,
    int? offset,
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.albumSublist,
          ApiParams.albumSublist(
            limit: limit,
            offset: offset,
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 二维码登录检测
  Future<Map<String, dynamic>> loginQrCheck({
    required String key,
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.loginQrCheck,
          ApiParams.loginQrCheck(
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
  }) =>
      _call(
          ApiModules.loginQrCreate,
          ApiParams.loginQrCreate(
            key: key,
            qrimg: qrimg,
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 二维码登录 key 生成
  Future<Map<String, dynamic>> loginQrKey({
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.loginQrKey,
          ApiParams.loginQrKey(
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 登录刷新
  Future<Map<String, dynamic>> loginRefresh({
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.loginRefresh,
          ApiParams.loginRefresh(
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 登录状态
  Future<Map<String, dynamic>> loginStatus({
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.loginStatus,
          ApiParams.loginStatus(
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 退出登录
  Future<Map<String, dynamic>> logout({
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.logout,
          ApiParams.logout(
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 推荐歌单
  Future<Map<String, dynamic>> personalized({
    int? limit,
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.personalized,
          ApiParams.personalized(
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
  }) =>
      _call(
          ApiModules.playlistDetail,
          ApiParams.playlistDetail(
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
  }) =>
      _call(
          ApiModules.playlistTrackAll,
          ApiParams.playlistTrackAll(
            id: id,
            s: s,
            limit: limit,
            offset: offset,
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 每日推荐歌曲
  Future<Map<String, dynamic>> recommendSongs({
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.recommendSongs,
          ApiParams.recommendSongs(
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
  }) =>
      _call(
          ApiModules.search,
          ApiParams.search(
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
  }) =>
      _call(
          ApiModules.songDetail,
          ApiParams.songDetail(
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
  }) =>
      _call(
          ApiModules.songUrlV1,
          ApiParams.songUrlV1(
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
  }) =>
      _call(
          ApiModules.songWikiSummary,
          ApiParams.songWikiSummary(
            id: id,
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 获取当前登录用户的账户详细信息，包括账户状态、会员信息等
  Future<Map<String, dynamic>> userAccount({
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.userAccount,
          ApiParams.userAccount(
            cookie: cookie,
            timestamp: timestamp,
          ));

  /// 用户详情
  Future<Map<String, dynamic>> userDetail({
    required String uid,
    String? cookie,
    String? timestamp,
  }) =>
      _call(
          ApiModules.userDetail,
          ApiParams.userDetail(
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
  }) =>
      _call(
          ApiModules.userPlaylist,
          ApiParams.userPlaylist(
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
  }) =>
      _call(
          ApiModules.userRecord,
          ApiParams.userRecord(
            uid: uid,
            type: type,
            cookie: cookie,
            timestamp: timestamp,
          ));
}
