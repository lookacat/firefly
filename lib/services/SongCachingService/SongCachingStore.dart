import 'dart:convert';
import 'dart:io';

import 'package:Firefly/models/Song.dart';
import 'package:Firefly/services/PythonDownloadService/PythonDownloadService.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
part 'SongCachingStore.g.dart';

class SongCachingStoreA = SongCachingStoreBase with _$SongCachingStoreA;

abstract class SongCachingStoreBase with Store {
	@observable
	Map<String, Song> cachedTracks = new Map<String, Song>();

	@action
	Future<void> addOrUpdateSong(Song song) async {
		cachedTracks[song.getId()] = song;
		await saveToLocalStorage();
	}
	@action 
	Future<String> downloadAndCacheSong(Song song) async {
		if(song.youtubeId == '' || song.youtubeId == null) {
			print("[Caching] No youtubeId provided!");
			return '';
		}
		String path = await PythonDownloadService.downloadVideo(song.youtubeId);
		song.isCached = true;
		song.cachedPath = path;
		addOrUpdateSong(song);
		
		print("[Caching] ${song.artist} ${song.title} is cached at ${song.cachedPath}");
		return song.cachedPath;
	}
	bool isSongIdCached(String id) {
		if(!cachedTracks.containsKey(id)) return false;
		return cachedTracks[id].isCached;
	}
	Song getCachedSong(String id) {
		if(!cachedTracks.containsKey(id)) return Song();
		return cachedTracks[id];
	}
	Future<void> saveToLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/song_cache');
		String encodedData = jsonEncode(cachedTracks);
		file.writeAsStringSync(encodedData);
	}
	Future<void> deleteLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/song_cache');
		file.writeAsStringSync('{}');
		loadLocalStorage();

		final temp = await getTemporaryDirectory();
		final music = Directory(temp.path + "/music/");
		await music.delete(recursive: true);
		print("Cache cleared...");
	}
	Future<void> loadLocalStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/song_cache');
      Map<String, dynamic> decoded = jsonDecode(file.readAsStringSync());
      Map<String, Song> loaded = new Map<String, Song>();
      for(String key in decoded.keys) {
        dynamic raw = decoded[key];
        Song song = Song.fromJson(raw);
        loaded[key] = song;
      }
      cachedTracks = loaded;
    } catch(Exception){

    }
	}
}
class SongCachingStore {
	static final SongCachingStoreA store = new SongCachingStoreA();
}



