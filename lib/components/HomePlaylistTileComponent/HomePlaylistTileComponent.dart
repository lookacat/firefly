import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/navigator/NavigatorStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePlaylistTileComponent extends StatefulWidget {
	final Playlist playlist;
	HomePlaylistTileComponent({
		Key key,
		@required this.playlist
	}) : super(key: key);

	@override
	_HomePlaylistTileComponentState createState() => _HomePlaylistTileComponentState();
}

class _HomePlaylistTileComponentState extends State<HomePlaylistTileComponent> {
	void onTapPlaylist() {
		Map<String, dynamic> parameters = new Map<String, dynamic>();
		parameters['playlist'] = this.widget.playlist;
		NavigatorStore.store.changeRoute('/playlist', parameters: parameters);
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			height: 90,
			width: 60,
			margin: EdgeInsets.only(left: 7, top: 5, right: 7),
			child: GestureDetector(
				onTap: onTapPlaylist,
				child: Column(
					children: <Widget>[
						Image(
							width: 60,
							height: 60,
							image: AssetImage('assets/default_playlist.png')
						),
						Container(
							height: 30,
							alignment: Alignment.center,
							child: Text(
								this.widget.playlist.name,
								overflow: TextOverflow.fade,
								maxLines: 1,
								softWrap: false,
								style: TextStyle(
									color: Colors.white,
									fontFamily: 'Circular',
									fontSize: 14,
									fontWeight: FontWeight.normal,
								)
							)
						)
					]
				)
			)
		);
	}
}