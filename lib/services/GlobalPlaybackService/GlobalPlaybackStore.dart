import 'package:mobx/mobx.dart';
part 'GlobalPlaybackStore.g.dart';

class GlobalPlaybackStoreA = GlobalPlaybackStoreBase with _$GlobalPlaybackStoreA;

abstract class GlobalPlaybackStoreBase with Store {
	@observable
	bool isPlaying = false;

	@observable
	String currentPlaylistId = '';

	@action
	void setPlayingStatus(bool value) {
		isPlaying = value;
	}
	@action
	void setCurrentPlaylistId(String value) {
		currentPlaylistId = value;
	}
}
class GlobalPlaybackStore {
	static final GlobalPlaybackStoreA store = new GlobalPlaybackStoreA();
}