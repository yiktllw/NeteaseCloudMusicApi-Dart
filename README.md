# 网易云音乐 Dart API

这是一个基于 Dart 语言的网易云音乐 API 实现，转换自原始的 Node.js 版本 [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)。

## 特性

- � **直接API调用**：无需启动服务器，直接调用API方法
- 🔐 **完整加密支持**：包含 WEAPI、EAPI、LinuxAPI 等多种加密方式
- �️ **安全实现**：使用 pointycastle 库实现 AES/RSA 加密算法
- 🍪 **Cookie管理**：自动处理登录状态和会话维护
- �📱 **设备模拟**：模拟真实设备请求头和参数
- 🌐 **IP代理支持**：支持自定义请求IP

## 安装

1. 确保已安装 Dart SDK (>=3.0.0)
2. 克隆项目到本地
3. 安装依赖：

```bash
dart pub get
```

## 使用方法

### 基本使用

```dart
import 'package:netease_cloud_music_api/netease_cloud_music_api.dart';

void main() async {
  final api = NeteaseCloudMusicApi();
  await api.init();
  
  // 搜索歌曲
  final searchResult = await api.search(keywords: '周杰伦', type: 1, limit: 10);
  print('搜索结果：$searchResult');
  
  // 获取歌曲详情
  final songDetail = await api.songDetail(ids: '347230');
  print('歌曲详情：$songDetail');
}
```

### 支持的API

#### 搜索相关
- `search()` - 搜索歌曲、专辑、歌手等
- `searchHot()` - 获取热门搜索
- `searchSuggest()` - 获取搜索建议

#### 歌曲相关
- `songDetail()` - 获取歌曲详情
- `songUrl()` - 获取歌曲播放URL
- `lyric()` - 获取歌词

#### 歌单相关
- `playlistDetail()` - 获取歌单详情
- `personalized()` - 获取推荐歌单
- `recommendSongs()` - 获取每日推荐歌曲

#### 用户相关
- `loginCellphone()` - 手机号登录

### 加密方式

支持网易云音乐的多种加密方式：

- **WEAPI**: Web端加密方式
- **EAPI**: 移动端加密方式  
- **LinuxAPI**: Linux客户端加密方式
- **API**: 无加密方式

### 设备模拟

支持多种设备类型模拟：

- PC (Windows/Mac)
- Android
- iPhone/iOS
- Linux

## API参考

### NeteaseCloudMusicApi

主要的API类，提供所有接口方法。

#### 方法

##### init()
初始化API，获取匿名token等必要信息。

```dart
await api.init();
```

##### search()
搜索歌曲、专辑、歌手等。

```dart
final result = await api.search(
  keywords: '搜索关键词',
  type: 1,        // 1:单曲, 10:专辑, 100:歌手, 1000:歌单, 1002:用户, 1004:MV
  limit: 30,      // 返回数量
  offset: 0,      // 偏移量
);
```

##### songDetail()
获取歌曲详情。

```dart
final result = await api.songDetail(ids: '347230,347231');
```

##### songUrl()
获取歌曲播放URL。

```dart
final result = await api.songUrl(
  id: '347230',
  br: '320000',   // 比特率
);
```

##### loginCellphone()
手机号登录。

```dart
final result = await api.loginCellphone(
  phone: '手机号',
  password: '密码',
  countrycode: '86',
);
```

## 与原项目的主要差异

1. **直接API调用**: 不需要启动HTTP服务器，直接调用API方法
2. **类型安全**: 使用Dart的强类型系统，提供更好的开发体验
3. **模块化设计**: 每个API功能独立模块，便于维护和扩展
4. **简化的加密**: 提供简化的加密实现，实际项目中建议使用专业加密库

## 注意事项

1. 本项目仅供学习交流使用
2. 加密算法为简化实现，生产环境建议使用专业加密库
3. 请遵守网易云音乐的使用条款
4. API接口可能会发生变化，请及时更新

## 贡献

欢迎提交 Issue 和 Pull Request。

## 许可证

MIT License
