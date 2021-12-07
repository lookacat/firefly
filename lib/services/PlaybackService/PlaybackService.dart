import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:Firefly/components/PlayerComponent/PlayerComponentStore.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/models/Song.dart';
import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackStore.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/services/PlaybackService/AudioBackgroundService.dart';
import 'package:Firefly/services/SongCachingService/SongCachingStore.dart';
import 'package:Firefly/services/WebApiService/WebApiService.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackService.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackServiceEventBus.dart';

void startAudioBackgroundTask() {
	AudioServiceBackground.run(() => AudioBackgroundTask());
}
class PlaybackService {
	static bool _isPlaying = false;
	static Song _currentSong;
	static bool isPlaying() {
		return _isPlaying;
	}
	static Future<void> syncBackgroundTaskAndPlayerComponent(Song song) async {
		// TODO: Fix that it doesn't load playlist when listining to solo song
		_currentSong = song;
		PlayerComponentStoreStore.store.setSong(song);
		String currentPlaylistId = GlobalPlaybackStore.store.currentPlaylistId;
		Playlist currentPlaylist = LibraryStore.store.getPlaylistById(currentPlaylistId);

		await AudioService.customAction('setCache', jsonEncode(SongCachingStore.store.cachedTracks));
		await AudioService.customAction('setPlaylist', jsonEncode(currentPlaylist));
	}
	static Future<void> playSong(Song song) async {
		await syncBackgroundTaskAndPlayerComponent(song);
		await AudioService.customAction('load', jsonEncode(song));
	}
	static Future<void> _streamAndCacheSong() async {
		_currentSong.youtubeId = await Api.getYoutubeIdFrom(_currentSong.title, _currentSong.artist);
		youtubePlayerEventBus.fire(ChangeTrackEvent(_currentSong));
		SongCachingStore.store.downloadAndCacheSong(_currentSong).then((_) async {
			// Sync new cache when song is downloaded
			await AudioService.customAction('setCache', jsonEncode(SongCachingStore.store.cachedTracks));
		});
	}
	static Future<void> _streamAndFlagCorruptedSong() async {
		_currentSong.youtubeId = await Api.getYoutubeIdFrom(_currentSong.title, _currentSong.artist);
		youtubePlayerEventBus.fire(ChangeTrackEvent(_currentSong));
		_currentSong.hasErrors = true;
		await SongCachingStore.store.addOrUpdateSong(_currentSong);
		await AudioService.customAction('setCache', jsonEncode(SongCachingStore.store.cachedTracks));
	}
	static void playbackStateStreamListener(PlaybackState state) {
		if(state.basicState == BasicPlaybackState.playing || state.basicState == BasicPlaybackState.buffering || state.basicState == BasicPlaybackState.connecting) {
			GlobalPlaybackStore.store.setPlayingStatus(true);
		}
		if(state.basicState == BasicPlaybackState.paused || state.basicState == BasicPlaybackState.stopped) {
			GlobalPlaybackStore.store.setPlayingStatus(false);
		}
		// Song in BackgroundService has changed
		if(state.basicState == BasicPlaybackState.songChanged) {
			MediaItem current = AudioService.queue.first;
			if(current.duration != 0) {
				PlayerComponentStoreStore.store.setDuration(current.duration);
			}
			_currentSong = new Song(artist: current.artist, title: current.title, image: current.artUri);
			PlayerComponentStoreStore.store.setSong(_currentSong);
		}
		if(state.basicState == BasicPlaybackState.streamAndCacheSong) {
			_streamAndCacheSong();
		}
		if(state.basicState == BasicPlaybackState.streamAndFlagCorruptedSong) {
			_streamAndFlagCorruptedSong();
		}
		if(state.basicState == BasicPlaybackState.pauseYoutubeStream) {
			YoutubePlaybackService.pauseVideo();
		}
		if(state.basicState == BasicPlaybackState.playYoutubeStream) {
			YoutubePlaybackService.playVideo();
		}
    PlayerComponentStoreStore.store.setPosition(state.currentPosition);
	}
	static Future<void> startAudioService() async {
		await AudioService.connect();
		await AudioService.start(
			backgroundTaskEntrypoint: startAudioBackgroundTask,
			notificationColor: 0xFFF05408,
			androidNotificationChannelName: 'Firefly Player',
			androidNotificationIcon: "drawable/firefly",
			enableQueue: true
		);
		AudioService.playbackStateStream.listen(playbackStateStreamListener);
	}
	static Future<void> togglePlaying() async {
		if(GlobalPlaybackStore.store.isPlaying) {
			AudioService.pause();
		}else {
			AudioService.play();
		}
	}
}