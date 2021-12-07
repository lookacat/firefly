import 'dart:convert';

import 'package:Firefly/models/Song.dart';
import 'package:uuid/uuid.dart';

class Playlist {
	String id;
	String name = "Unnamed";
	List<Song> trackList;
	Playlist({this.name}) {
		this.id = Uuid().v1();
		this.trackList = new List<Song>();
	}
	Playlist.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		name = json['name'];
		trackList = new List<Song>();
		jsonDecode(json['trackList']).forEach((dynamic raw) {
			trackList.add(Song.fromJson(raw));
		});
	}
	Map<String, dynamic> toJson() => {
		'id': id,
		'name': name,
		'trackList': jsonEncode(trackList)
	};
	Song getNextSong(Song song) {
		int i=0;
		int found=-1;
		this.trackList.forEach((Song e){
			if(e.getId() == song.getId()){
				found = i;
			}
			i++;
		});
		return trackList[found+1];
	}
	Song getPreviousSong(Song song) {
		int i=0;
		int found=1;
		this.trackList.forEach((Song e){
			if(e.getId() == song.getId()){
				found = i;
			}
			i++;
		});
		print("==================================================================");
		print(found);
		print(song.getId());
		return trackList[found-1];
	}
}
