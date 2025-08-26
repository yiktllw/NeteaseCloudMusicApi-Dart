// 自动生成的模块注册文件
// 请勿手动编辑此文件，运行 tools/auto_register_modules.dart 重新生成

import 'module_registry.dart';
import '../modules/album_sublist.dart';
import '../modules/login_qr_check.dart';
import '../modules/login_qr_create.dart';
import '../modules/login_qr_key.dart';
import '../modules/login_refresh.dart';
import '../modules/login_status.dart';
import '../modules/logout.dart';
import '../modules/personalized.dart';
import '../modules/playlist_detail.dart';
import '../modules/recommend_songs.dart';
import '../modules/search.dart';
import '../modules/song_detail.dart';
import '../modules/song_url_v1.dart';
import '../modules/song_wiki_summary.dart';
import '../modules/user_account.dart';
import '../modules/user_detail.dart';
import '../modules/user_playlist.dart';
import '../modules/user_record.dart';

/// 自动注册所有API模块
class AutoRegister {
  static bool _registered = false;
  
  /// 注册所有模块
  static void registerAllModules() {
    if (_registered) return;
    
    ModuleRegistry.register('albumSublist', albumSublist);
    ModuleRegistry.register('loginQrCheck', loginQrCheck);
    ModuleRegistry.register('loginQrCreate', loginQrCreate);
    ModuleRegistry.register('loginQrKey', loginQrKey);
    ModuleRegistry.register('loginRefresh', loginRefresh);
    ModuleRegistry.register('loginStatus', loginStatus);
    ModuleRegistry.register('logout', logout);
    ModuleRegistry.register('personalized', personalized);
    ModuleRegistry.register('playlistDetail', playlistDetail);
    ModuleRegistry.register('recommendSongs', recommendSongs);
    ModuleRegistry.register('search', search);
    ModuleRegistry.register('songDetail', songDetail);
    ModuleRegistry.register('songUrlV1', songUrlV1);
    ModuleRegistry.register('songWikiSummary', songWikiSummary);
    ModuleRegistry.register('userAccount', userAccount);
    ModuleRegistry.register('userDetail', userDetail);
    ModuleRegistry.register('userPlaylist', userPlaylist);
    ModuleRegistry.register('userRecord', userRecord);
    
    _registered = true;
  }
  
  /// 获取所有已注册的模块名称
  static List<String> getRegisteredModuleNames() {
    return [
      'albumSublist',
      'loginQrCheck',
      'loginQrCreate',
      'loginQrKey',
      'loginRefresh',
      'loginStatus',
      'logout',
      'personalized',
      'playlistDetail',
      'recommendSongs',
      'search',
      'songDetail',
      'songUrlV1',
      'songWikiSummary',
      'userAccount',
      'userDetail',
      'userPlaylist',
      'userRecord',
    ];
  }
  
  /// 获取模块总数
  static int getModuleCount() => 18;
}
