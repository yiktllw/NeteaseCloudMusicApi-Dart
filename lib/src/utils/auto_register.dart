// 自动生成的模块注册文件
// 请勿手动编辑此文件，运行 tools/auto_register_modules.dart 重新生成

import 'module_registry.dart';
import '../modules/login_cellphone.dart';
import '../modules/playlist.dart';
import '../modules/search.dart';
import '../modules/song_detail.dart';
import '../modules/song_url_v1.dart';
import '../modules/song_wiki_summary.dart';
import '../modules/user_detail.dart';
import '../modules/user_playlist.dart';
import '../modules/user_record.dart';

/// 自动注册所有API模块
class AutoRegister {
  static bool _registered = false;
  
  /// 注册所有模块
  static void registerAllModules() {
    if (_registered) return;
    
    print('正在注册 11 个API模块...');
    
    ModuleRegistry.register('loginCellphone', loginCellphone);
    ModuleRegistry.register('playlistDetail', playlistDetail);
    ModuleRegistry.register('personalized', personalized);
    ModuleRegistry.register('recommendSongs', recommendSongs);
    ModuleRegistry.register('search', search);
    ModuleRegistry.register('songDetail', songDetail);
    ModuleRegistry.register('songUrlV1', songUrlV1);
    ModuleRegistry.register('songWikiSummary', songWikiSummary);
    ModuleRegistry.register('userDetail', userDetail);
    ModuleRegistry.register('userPlaylist', userPlaylist);
    ModuleRegistry.register('userRecord', userRecord);
    
    _registered = true;
    print('✅ 所有模块注册完成');
  }
  
  /// 获取所有已注册的模块名称
  static List<String> getRegisteredModuleNames() {
    return [
      'loginCellphone',
      'playlistDetail',
      'personalized',
      'recommendSongs',
      'search',
      'songDetail',
      'songUrlV1',
      'songWikiSummary',
      'userDetail',
      'userPlaylist',
      'userRecord',
    ];
  }
  
  /// 获取模块总数
  static int getModuleCount() => 11;
}
