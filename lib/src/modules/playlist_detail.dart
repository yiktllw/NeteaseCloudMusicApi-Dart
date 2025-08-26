import '../utils/request.dart';
import '../types/track.dart';

// 歌单详情响应类型定义
typedef PlaylistDetailResponse = ({
  /// 200为成功
  int code,

  /// 歌单信息
  PlaylistInfo playlist,

  /// 歌曲权限信息，暂未使用
  List<PrivilegeInfo> privileges,
});

// 歌单信息类型
typedef PlaylistInfo = ({
  /// 歌单ID
  int id,

  /// 歌单名称
  String name,

  /// 歌单封面
  String coverImgUrl,

  /// 创建时间，UNIX时间戳
  int createTime,

  /// 创建者
  CreatorInfo creator,

  /// 播放次数
  int playCount,

  /// 歌曲的ID
  List<int> trackIds,

  /// 歌单内的歌曲
  List<ITrack> tracks,

  /// 歌曲数量
  int trackCount,

  /// 用户ID
  int userId,
});

// 创建者信息类型
typedef CreatorInfo = ({
  /// 用户ID
  int userId,

  /// 用户名
  String nickname,

  /// 用户头像
  String avatarUrl,
});

// 权限信息类型
typedef PrivilegeInfo = Map<String, dynamic>;

/// 歌单详情
// Future<PlaylistDetailResponse> playlistDetail(
Future<Map<String, dynamic>> playlistDetail(
  Map<String, dynamic> query,
  Future<Map<String, dynamic>> Function(
          String, Map<String, dynamic>, RequestOptions)
      request,
) async {
  final data = {
    'id': query['id'],
    'n': '100000',
    's': query['s'] ?? '8',
  };

  return await request(
      '/api/v6/playlist/detail', data, RequestOptions.create(query));
}
