import 'dart:core';

class Song {
	String title;
	String artist;
	String youtubeId;
	String image;
  bool hasErrors = false;
	bool isCached = false;
	String cachedPath = '';

	Song({this.title, this.artist, this.image});

	Song.fromJson(Map<String, dynamic> json)
		: title = json['title'],
		artist = json['artist'],
		youtubeId = json['youtubeId'],
		image = json['image'],
    hasErrors = json['hasErrors'],
		isCached = json['isCached'],
		cachedPath = json['cachedPath'];

	String getId() {
		if(title == null || artist == null) return '';
		return title.toLowerCase()+artist.toLowerCase();
	}

	Map<String, dynamic> toJson() => {
		'title': title,
		'artist': artist,
		'youtubeId': youtubeId,
		'image': image,
    'hasErrors': hasErrors,
		'isCached': isCached,
		'cachedPath': cachedPath
	};
}