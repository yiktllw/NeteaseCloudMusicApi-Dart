// ignore_for_file: avoid_print

import 'package:netease_cloud_music_api/src/netease_cloud_music_api_final.dart';
import 'dart:io';

import 'package:netease_cloud_music_api/src/utils/api_constants.dart';

void main() async {
  print('=== 网易云音乐API Dart版本 - 使用示例 ===\n');
  
  // 读取cookie
  String? cookie = "MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/api/clientlog;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/eapi/clientlog;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/neapi/feedback;;MUSIC_U=00A093BEBF7F8AECDD31276FDD9783FFF68F4B25BA9A31C3B2FE36741212D1D8AE94FD11D507999EACCCE958303D64728781A3F565C2E8825FF82071B691A3067702024191522DB97483A9F9F99A81D0BE4BCB7000FC6D387ADCD7D0DAA9DD2E20A1DFDDE33C1FA788A1B8D1A581223C3518BFE40F386385A12435E5EE5533850DB5583D04FBD4BFFCEE7151B0B213F437CF0A163A0A0C0803B55C54CE91774445570D275FA3B91C892914449818078F2C6F06B6DE80622F232A3AA0FB5EA466AA8EE650D55BDD3825D73794C15E06D9772E88EA144B1CC01437F2FFAA2E7405B4100F9434A8C0C5E1D4E5D5665B43CF369832536CA93DDF7FB67DEDBC44141F29EBB023FB23AFA306B8D661F9292A2F51EB4CE7870454002F4B2A75DC31F0925AF46BFEDE0984584E137B2352658FA84CDE28899CE69809CF080AC7477FAB714B; Max-Age=15552000; Expires=Sun, 25 Jan 2026 13:08:56 GMT; Path=/;;MUSIC_SNS=; Max-Age=0; Expires=Tue, 29 Jul 2025 13:08:56 GMT; Path=/;__csrf=2566b1b506b3c20fbec542739a8d23a6; Max-Age=1296010; Expires=Wed, 13 Aug 2025 13:09:06 GMT; Path=/;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/eapi/clientlog;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/neapi/clientlog;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/eapi/feedback;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/weapi/clientlog;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/wapi/clientlog;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/weapi/feedback;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/api/feedback;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/weapi/feedback;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/api/feedback;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/openapi/clientlog;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/openapi/clientlog;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/wapi/feedback;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/api/clientlog;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/weapi/clientlog;;NMTID=00OmpOJW6KWb9QPn0Nalkqt70J7wugAAAGYVkzjUw; Max-Age=315360000; Expires=Fri, 27 Jul 2035 13:08:56 GMT; Path=/;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/wapi/feedback;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/neapi/clientlog;;MUSIC_R_T=1481250625144; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/neapi/feedback;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/eapi/feedback;;MUSIC_A_T=1481250377026; Max-Age=2147483647; Expires=Sun, 16 Aug 2093 16:23:03 GMT; Path=/wapi/clientlog;";
  try {
    final cookieFile = File('cookie.txt');
    if (await cookieFile.exists()) {
      cookie = await cookieFile.readAsString();
    }
  } catch (e) {
    print('无法读取cookie文件: $e');
  }
  
  // 创建API实例
  final api = NeteaseCloudMusicApiFinal();
  
  try {
    // 1. 搜索歌曲
    print('🎵 搜索 "周杰伦" 的歌曲...');
    var searchResult = await api.call(ApiModules.search, {'keywords': '周杰伦', 'type': 1, 'limit': 3});
    var responseBody = searchResult['body'] as Map<String, dynamic>?;
    
    if (responseBody != null && responseBody['code'] == 200) {
      var searchData = responseBody['result'] as Map<String, dynamic>?;
      var songs = searchData?['songs'] as List?;
      
      if (songs != null && songs.isNotEmpty) {
        print('✅ 搜索成功，找到 ${songs.length} 首歌曲:');
        for (var i = 0; i < songs.length; i++) {
          var song = songs[i] as Map<String, dynamic>;
          var artists = song['ar'] as List?;
          var artistName = artists != null && artists.isNotEmpty ? artists[0]['name'] : '未知歌手';
          print('   ${i + 1}. ${song['name']} - $artistName');
        }
        
        // 2. 获取第一首歌的详细信息
        var firstSongId = songs[0]['id'].toString();
        print('\n🎤 获取歌曲详情...');
        var songDetailResult = await api.call(ApiModules.songDetail, ApiParams.songDetail(ids: firstSongId));
        responseBody = songDetailResult['body'] as Map<String, dynamic>?;
        
        if (responseBody != null && responseBody['code'] == 200) {
          var songDetails = responseBody['songs'] as List?;
          if (songDetails != null && songDetails.isNotEmpty) {
            var songDetail = songDetails[0] as Map<String, dynamic>;
            print('✅ 歌曲详情获取成功:');
            print('   歌曲ID: ${songDetail['id']}');
            print('   歌曲名: ${songDetail['name']}');
            print('   专辑: ${songDetail['al']['name']}');
            print('   时长: ${Duration(milliseconds: songDetail['dt']).inMinutes}:${(Duration(milliseconds: songDetail['dt']).inSeconds % 60).toString().padLeft(2, '0')}');
          }
        }
        
        // 3. 获取歌曲播放链接
        print('\n🔗 获取播放链接...');
        var urlResult = await api.call(ApiModules.songUrlV1, {'id': firstSongId, 'cookie': cookie ?? ''});
        responseBody = urlResult['body'] as Map<String, dynamic>?;
        
        if (responseBody != null && responseBody['code'] == 200) {
          var urlData = responseBody['data'] as List?;
          if (urlData != null && urlData.isNotEmpty && urlData[0]['url'] != null) {
            print('✅ 播放链接获取成功:');
            print('   URL: ${urlData[0]['url']}');
            print('   码率: ${urlData[0]['br']} kbps');
          } else {
            print('❌ 播放链接为空（可能需要VIP或版权限制）');
          }
        }
      }
    }
    
    // 4. 获取个性化推荐
    print('\n📻 获取个性化推荐...');
    var recommendResult = await api.call(ApiModules.personalized, {'limit': 5, 'cookie': cookie});
    responseBody = recommendResult['body'] as Map<String, dynamic>?;
    
    if (responseBody != null && responseBody['code'] == 200) {
      var playlists = responseBody['result'] as List?;
      if (playlists != null && playlists.isNotEmpty) {
        print('✅ 个性化推荐获取成功:');
        for (var i = 0; i < playlists.length; i++) {
          var playlist = playlists[i] as Map<String, dynamic>;
          print('   ${i + 1}. ${playlist['name']} (播放量: ${playlist['playCount']})');
        }
      }
    }
    
    // 5. 获取用户详情示例
    print('\n👤 获取用户详情...');
    var userResult = await api.api.userDetail(uid: "375334328", timestamp: DateTime.now().millisecondsSinceEpoch.toString());
    print(userResult);
    responseBody = userResult['body'] as Map<String, dynamic>?;
    
    if (responseBody != null && responseBody['code'] == 200) {
      var profile = responseBody['profile'] as Map<String, dynamic>?;
      if (profile != null) {
        print('✅ 用户详情获取成功:');
        print('   用户名: ${profile['nickname']}');
        print('   粉丝数: ${profile['followeds']}');
        print('   关注数: ${profile['follows']}');
      }
    }
    
    // 6. 显示API统计信息
    print('\n📊 API统计信息:');
    print('   注册的模块数量: ${api.getRegisteredModuleCount()}');
    print('   可用的API模块: ${api.getRegisteredModuleNames().join(', ')}');
    
  } catch (e, stackTrace) {
    print('❌ 发生错误: $e');
    print('堆栈跟踪: $stackTrace');
  }

  final result = await api.api.albumSublist(cookie: cookie, limit: 10, offset: 0, timestamp: DateTime.now().millisecondsSinceEpoch.toString());
  print(result);

  print('\n=== 示例完成 ===');
  print('💡 更多API用法请参考: test/test_all_converted_apis.dart');
  return;
}
