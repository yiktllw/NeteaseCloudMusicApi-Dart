import '../lib/src/netease_cloud_music_api_final.dart';
import 'dart:io';

void main() async {
  print('=== 网易云音乐API Dart版本 - 使用示例 ===\n');
  
  // 读取cookie
  String? cookie;
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
    var searchResult = await api.search(keywords: '周杰伦', type: 1, limit: 3);
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
        var songDetailResult = await api.songDetail(ids: firstSongId);
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
        var urlResult = await api.songUrlV1(id: firstSongId, level: 'standard');
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
    var recommendResult = await api.personalized(limit: 5, cookie: cookie);
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
    var userResult = await api.userDetail(uid: '32953014');
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
  
  print('\n=== 示例完成 ===');
  print('💡 更多API用法请参考: test/test_all_converted_apis.dart');
}
