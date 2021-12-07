import 'dart:async';
import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:Firefly/components/PlayerComponent/PlayerComponentStore.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/models/Song.dart';
import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackStore.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/services/SongCachingService/SongCachingStore.dart';
import 'package:Firefly/services/WebApiService/WebApiService.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackService.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackServiceEventBus.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';
import 'package:ansicolor/ansicolor.dart';

AnsiPen redTextBlueBackgroundPen = AnsiPen()..blue(bg: true)..red();

MediaControl playControl = MediaControl(
	androidIcon: 'drawable/play',
	label: 'Play',
	action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
	androidIcon: 'drawable/pause',
	label: 'Pause',
	action: MediaAction.pause
);

class GlobalPlaybackBackgroundTask extends BackgroundAudioTask {
	final AudioPlayer _audioPlayer = AudioPlayer();
	final _mediaItems = <String, MediaItem>{};
	final _completer = Completer();

	String currentSource = 'empty';
	Playlist currentPlaylist;
	Song currentSong;
	Map<String, Song> currentCache;
	int currentPosition = 0;

	final _queue = <MediaItem>[];

	Future<void> turnToYoutubePlayer() async {
		AudioServiceBackground.setQueue(<MediaItem>[new MediaItem(album: 'null', id: currentSong.getId(), title: currentSong.title, artist: currentSong.artist, artUri: currentSong.image)]);
		//await AudioServiceBackground.setState(controls: [pauseControl], basicState: BasicPlaybackState.errorLoadingAlreadyCachedSong);
	}
	Future<void> turnToYoutubePlayerForNewSongs() async {
		AudioServiceBackground.setQueue(<MediaItem>[new MediaItem(album: 'null', id: currentSong.getId(), title: currentSong.title, artist: currentSong.artist, artUri: currentSong.image)]);
		await AudioServiceBackground.setState(controls: [pauseControl], basicState: BasicPlaybackState.none);
	}
	@override
	Future<void> onStart() async {
		_audioPlayer.getPositionStream().listen((Duration current){
			currentPosition = current.inMicroseconds;
		});
		_audioPlayer.playbackEventStream.listen((AudioPlaybackEvent event) async {
			print(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
			print(event.state.toString());
			if(event.state == AudioPlaybackState.completed) {
				await onSongCompleted();
			}
			if(event.state == AudioPlaybackState.connecting) {
				print(redTextBlueBackgroundPen("Connecting!!!!!!!!!!!!!"));
			}
			if(event.state == AudioPlaybackState.none) {
				print(redTextBlueBackgroundPen("None!!!!!!!!!!!!!"));
			}
			if(event.buffering) {
				// If song doesnt load
				var timer = new Timer(const Duration(seconds: 1), () async {
					if(currentPosition == 0) {
						turnToYoutubePlayer();
					}
				});
				print(redTextBlueBackgroundPen("Buffering!!!!!!!!!!!!!"));
			}
			print(redTextBlueBackgroundPen(event.position.inSeconds.toString()));
		});
		await AudioServiceBackground.setState(
			controls: [playControl],
			basicState: BasicPlaybackState.paused);
		await AudioServiceBackground.androidForceEnableMediaButtons();
		await _completer.future;
	}
	@override
	Future<void> onPlay() async {
		print('playing $currentSource');
		
		if(currentSource != 'empty') {

			await _audioPlayer.play().catchError((_) async {
				
				/*print(redTextBlueBackgroundPen(_.toString()));
				AudioServiceBackground.setQueue(<MediaItem>[new MediaItem(album: 'null', id: currentSong.getId(), title: currentSong.title, artist: currentSong.artist, artUri: currentSong.image)]);
				await AudioServiceBackground.setState(controls: [pauseControl], basicState: BasicPlaybackState.error);*/
			});
		}		
		await AudioServiceBackground.setState(
			controls: [pauseControl], basicState: BasicPlaybackState.playing);
	}
	@override
	Future<void> onStop() async {
		_audioPlayer.pause();
		await AudioServiceBackground.setState(
			controls: [playControl], basicState: BasicPlaybackState.paused);
	}
	@override
	Future<void> onPause() async {
		_audioPlayer.pause();
		await AudioServiceBackground.setState(
			controls: [playControl], basicState: BasicPlaybackState.paused);
	}
	Future<void> onSongCompleted() async {
		await this.onSkipToNext();
	}
	@override
	void onAddQueueItem(MediaItem item) {
		_mediaItems[item.id] = item;
	}

	@override
	void onPlayFromMediaId(String mediaId) {
		_audioPlayer.stop();
		currentSource = mediaId;
		if(currentSource != 'empty') {
			_audioPlayer.setFilePath(currentSource).then((_) async {
				await this.onPlay();
			});
		}
	}
	@override
	void onClick(MediaButton button) {
		BasicPlaybackState current = AudioServiceBackground.state.basicState;
		if(current == BasicPlaybackState.playing) {
			onPause();
		}else{
			onPlay();
		}
	}
	@override
	Future<void> onSkipToNext() async {
		await AudioServiceBackground.setState(
			controls: [playControl], basicState: BasicPlaybackState.paused);
		Song next = this.currentPlaylist.getNextSong(this.currentSong);
		this.currentSong = this.currentCache[next.getId()];
		if(this.currentSong == null) {
			this.currentSong = next;
		}
		if(this.currentSong.isCached) {
			onPlayFromMediaId(this.currentSong.cachedPath);
		}else {
			turnToYoutubePlayerForNewSongs();
		}
		updateMediaItem();
		this.onPlay();
	}
	@override
	Future<void> onSkipToPrevious() async {
		await AudioServiceBackground.setState(
			controls: [playControl], basicState: BasicPlaybackState.paused);
		Song pre = this.currentPlaylist.getPreviousSong(this.currentSong);
		this.currentSong = this.currentCache[pre.getId()];
		if(this.currentSong == null) {
			this.currentSong = pre;
		}
		if(currentSong.isCached) {
			onPlayFromMediaId(this.currentSong.cachedPath);
		}else{
			turnToYoutubePlayerForNewSongs();
		}
		updateMediaItem();
		this.onPlay();
	}
	@override
	Future<void> onCustomAction(String name, dynamic arguments) async {
		switch (name) {
			case "setPlaylist":
				setPlaylist(arguments as String);
				break;
			case "setSong":
				setSong(arguments as String);
				break;
			case "setCache":
				setCache(arguments as String);
				break;
		}
	}
	void updateMediaItem() {
		AudioServiceBackground.setMediaItem(new MediaItem(
			id: Uuid().v1(),
			album: currentSong.artist,
			title: currentSong.title,
			artist: currentSong.artist
		));
	}
	void setCache(String cache) {
		Map<String, dynamic> decoded = jsonDecode(cache);
		this.currentCache = new Map<String, Song>();
		for(String key in decoded.keys) {
			dynamic raw = decoded[key];
			Song song = Song.fromJson(raw);
			this.currentCache[key] = song;
		}
	}
	void setSong(String song) {
		this.currentSong = Song.fromJson(jsonDecode(song));
		updateMediaItem();
	}
	void setPlaylist(String playlist) {
		this.currentPlaylist = Playlist.fromJson(jsonDecode(playlist));
	}
}

void myBackgroundTaskEntrypoint() {
	AudioServiceBackground.run(() => GlobalPlaybackBackgroundTask());
}
class GlobalPlaybackService {
	static bool isCurrentSongStreamed = true;
	static Future<void> playSong(Song song) async {
		PlayerComponentStoreStore.store.setSong(song);
		String currentPlaylistId = GlobalPlaybackStore.store.currentPlaylistId;
		Playlist currentPlaylist = LibraryStore.store.getPlaylistById(currentPlaylistId);

		await AudioService.customAction('setSong', jsonEncode(song));
		await AudioService.customAction('setCache', jsonEncode(SongCachingStore.store.cachedTracks));
		await AudioService.customAction('setPlaylist', jsonEncode(currentPlaylist));

		if(!SongCachingStore.store.isSongIdCached(song.getId())) {
			// Stream on YoutubePlayer
			isCurrentSongStreamed = true;
			_streamAndDownloadSong(song);
		}else{
			// Play on Audio Service
			isCurrentSongStreamed = false;
			_playCachedSong(song);
		}
	}
	static Future<void> _streamAndDownloadSong(Song song) async {
		song.youtubeId = await Api.getYoutubeIdFrom(song.title, song.artist);
		youtubePlayerEventBus.fire(ChangeTrackEvent(song));
		await AudioService.playFromMediaId('empty');
		await AudioService.play();
		await SongCachingStore.store.downloadAndCacheSong(song);
	}
	static Future<void> _playCachedSong(Song song) async {
		Song cached = SongCachingStore.store.getCachedSong(song.getId());
		await AudioService.customAction('setCache', jsonEncode(SongCachingStore.store.cachedTracks)); // Reload cache for service because new file is there
		await AudioService.playFromMediaId(cached.cachedPath);
		await AudioService.play();
	}
	static void _onPlayingState() {
		GlobalPlaybackStore.store.setPlayingStatus(true);
		if(isCurrentSongStreamed) {
			YoutubePlaybackService.playVideo();
		}
	}
	static void _onPausedState() {
		GlobalPlaybackStore.store.setPlayingStatus(false);
		YoutubePlaybackService.pauseVideo();
	}
	static Future<void> startAudioService() async {
		await AudioService.connect();
		await AudioService.start(
			backgroundTaskEntrypoint: myBackgroundTaskEntrypoint,
			notificationColor: 0xFFF05408,
			androidNotificationChannelName: 'Firefly Player',
			androidNotificationIcon: "drawable/firefly",
			enableQueue: true
		);
		await AudioService.play();
		AudioService.playbackStateStream.listen((PlaybackState state) {
			/*if(state.basicState == BasicPlaybackState.errorLoadingAlreadyCachedSong) {
				print(redTextBlueBackgroundPen("ERROR!!"));
				MediaItem current = AudioService.queue.first;
				Song currentSong = new Song(artist: current.artist, title: current.title, image: current.artUri);
				_streamAndDownloadSong(currentSong);
				PlayerComponentStoreStore.store.setSong(currentSong);
			}
			if(state.basicState == BasicPlaybackState.none) {
				print(redTextBlueBackgroundPen("None!!"));
				MediaItem current = AudioService.queue.first;
				Song currentSong = new Song(artist: current.artist, title: current.title, image: current.artUri);
				if(!SongCachingStore.store.isSongIdCached(currentSong.getId())) {
					_streamAndDownloadSong(currentSong);
				}else {
					_playCachedSong(currentSong);
				}
				PlayerComponentStoreStore.store.setSong(currentSong);
			}
			if(state.basicState == BasicPlaybackState.stopped) {
				_onPausedState();
				print(redTextBlueBackgroundPen("stopped!!"));
			}
			if(state.basicState == BasicPlaybackState.playing) {
				_onPlayingState();
				print(redTextBlueBackgroundPen("PLAYING!!"));
			}
			if(state.basicState == BasicPlaybackState.paused) {
				_onPausedState();
				print(redTextBlueBackgroundPen("PAUSE!!"));
			}*/
		});
	}
	static Future<void> play() async {
		await AudioService.play();
	}
	static Future<void> pause() async {
		await AudioService.pause();
	}
	static Future<void> toggleVideoPlaying() async {
		if(GlobalPlaybackStore.store.isPlaying) {
			await pause();
		}else {
			await play();
		}
	}
}