import 'package:event_bus/event_bus.dart';
import 'package:Firefly/models/Song.dart';

final EventBus youtubePlayerEventBus = new EventBus();

class ChangeTrackEvent {
	Song song;
	ChangeTrackEvent(this.song);
}