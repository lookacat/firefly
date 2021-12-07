import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackStore.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:Firefly/services/WebApiService/WebApiService.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackServiceEventBus.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackServiceStore.dart';

class YoutubePlaybackService{
	static const platform = const MethodChannel('flutter.native/helper');
	
	static void initializeAndBindEvents() {
		Api.getYoutubeIdFrom("test", "").then((String id) {
			try {
				platform.invokeMethod('init', { "id": id });
			} on PlatformException catch (e) {
				print("Failed to Invoke: '${e.message}'.");
			}
		});
		youtubePlayerEventBus.on<ChangeTrackEvent>().listen((event) {
			cueVideo(event.song.youtubeId);
		});
	}

	static Future<void> cueVideoAsync(String id) async {
		try {
			await platform.invokeMethod('load', {"id": id});
		} on PlatformException catch (e) {
			print("Failed to Invoke: '${e.message}'.");
		}
	}
	static void cueVideo(String id) {
		YoutubePlaybackServiceStore.store.setPlayingStatus(true);
		cueVideoAsync(id);
	}
	static Future<void> pauseVideo() async {
		YoutubePlaybackServiceStore.store.setPlayingStatus(false);
		try {
			await platform.invokeMethod('pause');
		} on PlatformException catch (e) {
			print("Failed to Invoke: '${e.message}'.");
		}
	}
	static Future<void> playVideo() async {
		YoutubePlaybackServiceStore.store.setPlayingStatus(true);
		try {
			await platform.invokeMethod('play');
		} on PlatformException catch (e) {
			print("Failed to Invoke: '${e.message}'.");
		}
		
	}
	static void toggleVideoPlaying() {
		if(YoutubePlaybackServiceStore.store.isPlaying) {
			AudioService.pause();
		}else {
			AudioService.play();
		}
	}
}