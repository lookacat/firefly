import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:Firefly/models/Song.dart';

import 'package:beautifulsoup/beautifulsoup.dart';

class Api {
	static Future<List<Song>> getGeniusSearchResults(String query) async {
		List<Song> results = new List<Song>();
		final response = await http.get('https://genius.com/api/search/song?page=1&q=$query');
		if (response.statusCode == 200) {
			dynamic result = json.decode(response.body);
			dynamic sections = result['response']['sections'];
			dynamic songs;
			sections.forEach((result){
				if(result['type'] == 'song') songs = result['hits'];
			});
			songs.forEach((song) {
				results.add(new Song(
					title: song['result']['title'],
					artist: song['result']['primary_artist']['name'],
					image: song['result']['song_art_image_thumbnail_url']
				));
			});
		}
		return results;
	}
	static List<Map<String, dynamic>> getMultiSearchResults(String query) {
		//TODO: Search different APIS and find Unique artists+title. Catch errors in case one API goes down
		return new List<Map<String, dynamic>>();
	}
	static Future<List<String>> getYoutubeIdsFrom(String artist, String title) async {
		var client = new HttpClient();
		client.userAgent = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)';
		List<String> results = new List<String>();
		await client.getUrl(Uri.parse("https://www.youtube.com/results?search_query=$artist $title&pbj=1"))
		.then((HttpClientRequest request){
			return request.close();
		})
		.then((HttpClientResponse response) async {
			String contents = await response.transform(utf8.decoder).join();
			var soup = Beautifulsoup(contents);
			for(dynamic video in soup.find_all('.yt-uix-tile-link')) {
				String url = soup.attr(video, 'href');
				if(url.startsWith('/watch?v=')) {
					String result = url.replaceAll('/watch?v=', '');
					results.add(result);
				}
			}
		});
		return results;
	}
	static Future<String> getYoutubeIdFrom(String artist, String title) async {
		String result = '';
		await Api.getYoutubeIdsFrom(artist, title).then((List<String> results) {
			result = results[0];
		});
		return result;
	}
}