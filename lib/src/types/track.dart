///  单曲数据结构，含歌曲的基本信息、专辑信息、歌手信息以及播放相关的元数据
typedef ITrack = ({
  /// 歌曲 id，唯一标识
  int id,

  /// 歌曲名
  String name,

  /// 歌曲别名
  String tns,

  /// 专辑信息
  ({
    /// 专辑 id，唯一标识
    int id,

    /// 专辑名
    String name,

    /// 专辑封面
    String picUrl,

    /// 专辑别名
    String tns,
  }) al,

  /// 歌手信息列表
  List<
      ({
        /// 歌手 id，唯一标识
        int id,

        /// 歌手名
        String name,

        /// 歌手别名
        String tns,
      })> ar,

  /// 专辑封面地址
  String? picUrl,

  /// 专辑序号
  int cd,

  /// 专辑内歌曲序号
  int no,

  /// 专辑内歌曲简称
  String? reelName,

  /// 专辑内歌曲reel序号
  int reelIndex,

  /// 专辑内歌曲在reel中的序号
  int songInReelIndex,

  /// 歌曲时长（毫秒）
  int dt,

  /// 歌曲流行度, 0-100的整数
  int pop,

  /// 歌曲播放次数
  int playCount,

  /// 歌词列表
  List<String> lyrics,

  /// higher质量信息
  dynamic h,

  /// standard质量信息
  dynamic l,

  /// lossless质量信息
  dynamic sq,

  /// hi-res质量信息
  dynamic hr,

  /// 高清环绕声信息
  dynamic jyeffect,

  /// 沉浸环绕声信息
  dynamic sky,

  /// 超清母带信息
  dynamic jymaster,

  /// 原始序号, 用于歌单内歌曲排序
  int originalIndex,

  /// 是否为本地歌曲
  bool local,

  /// 本地歌曲路径
  String localPath,
});
