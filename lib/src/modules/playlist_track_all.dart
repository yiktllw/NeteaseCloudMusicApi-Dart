import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 获取歌单所有歌曲数据
///
/// [query] 查询参数
/// - id: 歌单ID (必填)
/// - limit: 限制获取歌曲数量，默认为无限
/// - offset: 偏移量，默认为 0
/// - s: 歌单最近的收藏者数量，默认为 8
///
/// 通过传过来的歌单id拿到所有歌曲数据
/// 支持传递参数limit来限制获取歌曲的数据数量
/// 例如: /playlist/track/all?id=7044354223&limit=10
Future<Map<String, dynamic>> playlistTrackAll(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'id': query['id'],
    'n': 100000,
    's': query['s'] ?? 8,
  };

  // 不放在data里面避免请求带上无用的数据
  final limit =
      int.tryParse(query['limit']?.toString() ?? '') ?? (1 << 30); // 默认无限大
  final offset = int.tryParse(query['offset']?.toString() ?? '') ?? 0;

  // 首先获取歌单详情以获取trackIds
  final playlistDetailResult = await request(
      '/api/v6/playlist/detail', data, RequestOptions.create(query));

  if (playlistDetailResult['status'] != 200 ||
      playlistDetailResult['body'] == null ||
      playlistDetailResult['body']['playlist'] == null ||
      playlistDetailResult['body']['playlist']['trackIds'] == null) {
    throw Exception('获取歌单详情失败');
  }

  final trackIds = playlistDetailResult['body']['playlist']['trackIds'] as List;

  if (trackIds.isEmpty) {
    return {
      'status': 200,
      'body': {
        'songs': [],
        'code': 200,
      },
    };
  }

  // 获取指定范围的trackIds
  final startIndex = offset;
  final endIndex = offset + limit;
  final selectedTrackIds = trackIds.sublist(
    startIndex.clamp(0, trackIds.length),
    endIndex.clamp(0, trackIds.length),
  );

  if (selectedTrackIds.isEmpty) {
    return {
      'status': 200,
      'body': {
        'songs': [],
        'code': 200,
      },
    };
  }

  // 构建歌曲详情请求数据
  final idsData = {
    'c':
        '[${selectedTrackIds.map((item) => '{"id":${item['id'] ?? item}}').join(',')}]',
  };

  // 获取歌曲详情
  final songsResult = await request(
    '/api/v3/song/detail',
    idsData,
    RequestOptions.create(query, crypto: 'weapi'),
  );

  return songsResult;
}

/// 注册歌单所有歌曲模块
void registerPlaylistTrackAllModule() {
  ModuleRegistry.register('playlistTrackAll', playlistTrackAll);
}
