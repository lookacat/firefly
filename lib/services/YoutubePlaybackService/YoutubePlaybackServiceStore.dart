import 'package:mobx/mobx.dart';
part 'YoutubePlaybackServiceStore.g.dart';

class YoutubePlaybackServiceStoreA = YoutubePlaybackServiceStoreBase with _$YoutubePlaybackServiceStoreA;

abstract class YoutubePlaybackServiceStoreBase with Store {
	@observable
	bool isPlaying = false;

	@action
	void setPlayingStatus(bool value) {
		isPlaying = value;
	}
}
class YoutubePlaybackServiceStore {
	static final YoutubePlaybackServiceStoreA store = new YoutubePlaybackServiceStoreA();
}
