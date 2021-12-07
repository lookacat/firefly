import 'package:Firefly/models/Song.dart';
import 'package:mobx/mobx.dart';
part 'PlayerComponentStore.g.dart';

class PlayerComponentStoreA = PlayerComponentStoreBase with _$PlayerComponentStoreA;

abstract class PlayerComponentStoreBase with Store {
	@observable
	Song song = new Song();
	
	@observable
	int position = 0;

	@observable
	int duration = 0;

	@action
	void setSong(Song value) {
		song = value;
	}
	@action
	void setPosition(int pos) {
		position = pos;
	}
	@action
	void setDuration(int pos) {
		duration = pos;
	}
}
class PlayerComponentStoreStore {
	static final PlayerComponentStoreA store = new PlayerComponentStoreA();
}
