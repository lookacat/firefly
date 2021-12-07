import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/models/Song.dart';
import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackService.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

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

enum CurrentPlayerType {
	YOUTUBE,
	LOCAL_FILE
}

class AudioBackgroundTask extends BackgroundAudioTask {
	final _completer = Completer();
	final _audioPlayer = AudioPlayer();
	final _mediaItems = <String, MediaItem>{};
	Playlist currentPlaylist;
	Song currentSong;
	Map<String, Song> currentCache;
	CurrentPlayerType currentPlayer;
	int currentPosition;

	Future<void> onSongCompleted() async {
		await this.onSkipToNext();
	}
	void onBufferingCheckErrors() {
		Song cached = this.currentCache[this.currentSong.getId()];
		if(cached == null) {
			cached = this.currentSong;
		}
		this.currentSong = cached;
		String songId = currentSong.getId();
		new Timer(const Duration(seconds: 1), () async {
			if(currentPosition == 0 && currentSong.getId() == songId) {
				await streamAndFlagCorruptedSong();
			}
		});
	}
	void audioPlaybackEventListener(AudioPlaybackEvent event) async {
		if(event.state == AudioPlaybackState.completed) {
			await onSongCompleted();
		}
	}
	@override
	void onAddQueueItem(MediaItem item) {
		_mediaItems[item.id] = item;
	}
	@override
	Future<void> onStart() async {
		_audioPlayer.durationStream.listen((Duration current) async {
			await songChanged(duration: current.inMicroseconds);
		});
		_audioPlayer.getPositionStream().listen((Duration current) async {
			currentPosition = current.inMicroseconds;
			BasicPlaybackState state = AudioServiceBackground.state.basicState;
			await AudioServiceBackground.setState(
				controls: state == BasicPlaybackState.playing ? [pauseControl] : [playControl],
				basicState: state,
				position: currentPosition);
		});
		_audioPlayer.playbackEventStream.listen(audioPlaybackEventListener);
		await AudioServiceBackground.setState(
			controls: [playControl],
			basicState: BasicPlaybackState.paused);
		await AudioServiceBackground.androidForceEnableMediaButtons();
		await _completer.future;
	}
	@override
	void onSeekTo(int position) {
		_audioPlayer.seek(Duration(milliseconds: position));
	}
	Future<void> loadSongFromCache() async {
		BasicPlaybackState state = AudioServiceBackground.state.basicState;
		currentPlayer = CurrentPlayerType.LOCAL_FILE;
		if(state == BasicPlaybackState.playing) {
			try{
				await _audioPlayer.stop();
			}catch(Exception) {}
		}
		_audioPlayer.setFilePath(currentSong.cachedPath).then((_) async {
			await pauseYoutubeStream();
			await AudioServiceBackground.setState(
				controls: [pauseControl],
				basicState: BasicPlaybackState.playing
			);
			try {
				await _audioPlayer.play();
			}catch(Exception) {}
		});
		onBufferingCheckErrors();
	}
	Future<void> songChanged({int duration=0}) async {
		await AudioServiceBackground.setQueue(<MediaItem>[
			new MediaItem(
				album: 'null', 
				id: currentSong.getId(), 
				title: currentSong.title, 
				artist: currentSong.artist, 
				artUri: currentSong.image,
				duration: duration
			)
		]);
		BasicPlaybackState before = AudioServiceBackground.state.basicState;
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.songChanged
		);
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: before
		);
	}
	Future<void> streamAndFlagCorruptedSong() async {
		BasicPlaybackState state = AudioServiceBackground.state.basicState;
		if(state == BasicPlaybackState.playing) {
			try {
				await _audioPlayer.pause();
			}catch(Exception) {}
		}
		currentPlayer = CurrentPlayerType.YOUTUBE;
		BasicPlaybackState before = AudioServiceBackground.state.basicState;
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.streamAndFlagCorruptedSong
		);
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.playing
		);
	}
	Future<void> streamAndCacheSong() async {
		BasicPlaybackState state = AudioServiceBackground.state.basicState;
		if(state == BasicPlaybackState.playing) {
			try {
				await _audioPlayer.pause();
			}catch(Exception) {}
		}
		currentPlayer = CurrentPlayerType.YOUTUBE;
		BasicPlaybackState before = AudioServiceBackground.state.basicState;
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.streamAndCacheSong
		);
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.playing
		);
	}

	Future<void> pauseYoutubeStream() async {
		BasicPlaybackState before = AudioServiceBackground.state.basicState;
		await AudioServiceBackground.setState(
			controls: [playControl], 
			basicState: BasicPlaybackState.pauseYoutubeStream
		);
		await AudioServiceBackground.setState(
			controls: [playControl], 
			basicState: before
		);
	}
	Future<void> playYoutubeStream() async {
		BasicPlaybackState before = AudioServiceBackground.state.basicState;
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.playYoutubeStream
		);
		await AudioServiceBackground.setState(
			controls: [pauseControl], 
			basicState: BasicPlaybackState.playing
		);
	}
	@override
	Future<void> onClick(MediaButton button) async {
		BasicPlaybackState current = AudioServiceBackground.state.basicState;
		if(current == BasicPlaybackState.playing) {
			await onPause();
		}else{
			await onPlay();
		}
	}
	Future<void> loadSong({String song=''}) async {
		if(song != '') {
			await setSong(song);
		}
		BasicPlaybackState state = AudioServiceBackground.state.basicState;
		if(state == BasicPlaybackState.playing) {
			try{
				await _audioPlayer.stop();
			}catch(Exception) {}
		}
		await pauseYoutubeStream();
		await songChanged();
		Song cached = this.currentCache[this.currentSong.getId()];
		if(cached == null) {
			cached = this.currentSong;
		}
		this.currentSong = cached;
		await updateMediaItem();
		if(cached.isCached && cached.hasErrors == false) {
			await pauseYoutubeStream();
			await loadSongFromCache();
		}else {
			await streamAndCacheSong();
			//await playYoutubeStream();
		}
	}
	@override
	Future<void> onPlay() async {
		BasicPlaybackState state = AudioServiceBackground.state.basicState;
		if(this.currentPlayer == CurrentPlayerType.LOCAL_FILE) {
			await pauseYoutubeStream();
			if(state == BasicPlaybackState.paused || state == BasicPlaybackState.stopped) {
				try {
					await AudioServiceBackground.setState(
						controls: [pauseControl], 
						basicState: BasicPlaybackState.playing
					);
					await _audioPlayer.play();
				}catch(Exception) {}
			}
		}else if(this.currentPlayer == CurrentPlayerType.YOUTUBE) {
			try {
				await _audioPlayer.pause();
			}catch(Exception) {}
			await AudioServiceBackground.setState(
				controls: [pauseControl], 
				basicState: BasicPlaybackState.playing
			);
			await playYoutubeStream();
		}
		
	}
	@override
	Future<void> onPause() async {
		try{
			await _audioPlayer.pause();
		}catch(Exception) {}
		await pauseYoutubeStream();
		await AudioServiceBackground.setState(
			controls: [playControl],
			basicState: BasicPlaybackState.paused
		);
	}
	@override
	Future<void> onStop() async {
		await onPause();
	}
	Song getPrevious() {
		Song pre = this.currentPlaylist.getPreviousSong(this.currentSong);
		Song cachedPre = this.currentCache[pre.getId()];
		if(cachedPre == null) {
			cachedPre = pre;
		}
		return cachedPre;
	}
	Song getNext() {
		Song next = this.currentPlaylist.getNextSong(this.currentSong);
		Song cachedNext = this.currentCache[next.getId()];
		if(cachedNext == null) {
			cachedNext = next;
		}
		return cachedNext;
	}
	@override
	Future<void> onSkipToNext() async {
		this.currentSong = getNext();
		await updateMediaItem();
		await this.loadSong();
	}
	@override
	Future<void> onSkipToPrevious() async {
		this.currentSong = getPrevious();
		await updateMediaItem();
		await this.loadSong();
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
	Future<void> updateMediaItem() async {
		await AudioServiceBackground.setMediaItem(new MediaItem(
			id: Uuid().v1(),
			album: currentSong.artist,
			title: currentSong.title,
			artist: currentSong.artist
		));
		await AudioServiceBackground.androidForceEnableMediaButtons();
	}
	Future<void> setSong(String song) async {
		this.currentSong = Song.fromJson(jsonDecode(song));
		await updateMediaItem();
	}
	void setPlaylist(String playlist) {
		this.currentPlaylist = Playlist.fromJson(jsonDecode(playlist));
	}
	@override
	Future<void> onCustomAction(String name, dynamic arguments) async {
		switch (name) {
			case "setPlaylist":
				setPlaylist(arguments as String);
				break;
			case "setSong":
				await setSong(arguments as String);
				break;
			case "setCache":
				setCache(arguments as String);
				break;
			case "load":
				await loadSong(song: arguments as String);
				break;
		}
	}

}