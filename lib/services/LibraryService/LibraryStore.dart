import 'dart:convert';
import 'dart:io';

import 'package:Firefly/models/Song.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
part 'LibraryStore.g.dart';

class LibraryStoreA = LibraryStoreBase with _$LibraryStoreA;

abstract class LibraryStoreBase with Store {
	@observable
	List<Playlist> playlists = new List<Playlist>();

	@action
	void addPlaylist(Playlist playlist) {
		playlists.add(playlist);
		saveToLocalStorage();
	}

	@action
	void updatePlaylist(Playlist playlist) {
		playlists.asMap().forEach((index, element) {
			if(element.id == playlist.id) {
				playlists[index].name = playlist.name;
				playlists[index].trackList = playlist.trackList;
			}
		});
		saveToLocalStorage();
	}

	@action
	void addTrackToPlaylist(Song track, String id) {
		playlists.asMap().forEach((index, element) {
			if(element.id == id) {
				playlists[index].trackList.add(track);
			}
		});
		saveToLocalStorage();
	}
	@action
	void removeTrackFromPlaylist(int trackIndex, String id) {
		playlists.asMap().forEach((index, element) {
			if(element.id == id) {
				Playlist selected = playlists[index];
				selected.trackList.removeAt(trackIndex);
				playlists[index] = selected;
			}
		});	
		saveToLocalStorage();
	}
	@action
	void removePlaylist(String id) {
		playlists.asMap().forEach((index, element) {
			if(element.id == id) {
				playlists.removeAt(index);
			}
		});
		saveToLocalStorage();
	}

	Playlist getPlaylistById(String id) {
		Playlist result;
		playlists.forEach((element) {
			if(element.id == id) result = element;
		});
		return result;
	}

	List<Playlist> getPlaylistsByName(String name) {
		List<Playlist> results = new List<Playlist>();
		playlists.forEach((element) {
			if(element.name == name) results.add(element);
		});
		return results;
	}

	Future<void> saveToLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/playlists');
		String encodedData = jsonEncode(playlists);
		file.writeAsStringSync(encodedData);
	}
	Future<void> deleteLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/playlists');
		file.writeAsStringSync('[]');
		loadLocalStorage();
	}
	Future<void> loadLocalStorage() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/playlists');
		List<dynamic> decoded = jsonDecode(file.readAsStringSync());
		List<Playlist> loaded = new List<Playlist>();
		decoded.forEach((dynamic raw) {
			loaded.add(Playlist.fromJson(raw));
		});
		playlists = loaded;
	}

}
class LibraryStore {
	static final LibraryStoreA store = new LibraryStoreA();
}



