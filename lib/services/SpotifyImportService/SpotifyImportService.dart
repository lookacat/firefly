import 'dart:convert';
import 'dart:io';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:http/http.dart' as http;
import 'package:Firefly/models/Song.dart';

class SpotifyImportService {
	static String oauthToken = '';

	static String extractIdFromUrl(String url) {
		int index1 = url.indexOf('playlist/')+9;
		String subString = url.substring(index1, url.length);
		int index2 = subString.indexOf('?');
		return subString.substring(0, index2);
	} 
	static Future<void> importPlaylist(String url) async {
		String id = extractIdFromUrl(url);

		List<Song> results = new List<Song>();
		final response = await http.get(
			'https://api.spotify.com/v1/playlists/$id?type=track%2Cepisode&market=DE',
			headers: { HttpHeaders.authorizationHeader: "Bearer $oauthToken" }
		);
		if (response.statusCode == 200) {
			dynamic result = json.decode(response.body);
			Playlist playlist = new Playlist(
				name: result['name'] as String
			);
			dynamic tracks = result['tracks']['items'];
			tracks.forEach((dynamic element) {
				try{
					dynamic track = element['track'];
					Song song = new Song(
						title: track['name'],
						image: track['album']['images'][1]['url'],
						artist: track['artists'][0]['name']
					);
					playlist.trackList.add(song);
				}catch(Exception) {
					print("could not import song!");
				}
			});
			LibraryStore.store.addPlaylist(playlist);
			print("Imported Playlist");
		}else if(response.statusCode == 400 || response.statusCode == 401) {
			print("Refreshing token");
			final oauthRequest = await http.get('https://open.spotify.com/get_access_token?reason=transport&productType=web_player');
			if (oauthRequest.statusCode == 200) {
				dynamic result = json.decode(oauthRequest.body);
				oauthToken = result['accessToken'];
				await importPlaylist(url);
			}else{
				print("Error refreshing Spotify token ${response.statusCode}");
			}
		}
		return results;
	}
}