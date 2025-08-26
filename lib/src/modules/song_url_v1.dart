import '../utils/request.dart';
import '../utils/module_registry.dart';

/// 歌曲链接 - v1
/// 此版本不再采用 br 作为音质区分的标准
/// 而是采用 standard, exhigh, lossless, hires, jyeffect(高清环绕声), sky(沉浸环绕声), jymaster(超清母带) 进行音质判断
Future<Map<String, dynamic>> songUrlV1(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = <String, dynamic>{
    'ids': '[${query['id']}]',
    'level': query['level'],
    'encodeType': 'flac',
  };

  if (data['level'] == 'sky') {
    data['immerseType'] = 'c51';
  }

  return await request(
      '/api/song/enhance/player/url/v1', data, RequestOptions.create(query));
}

/// 注册歌曲链接模块
void registerSongUrlV1Module() {
  ModuleRegistry.register('songUrlV1', songUrlV1);
}
