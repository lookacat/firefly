import 'package:Firefly/components/Dialogs/SongMediaPlayerDialog/SongMediaPlayerDialog.dart';
import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackStore.dart';
import 'package:Firefly/services/PlaybackService/PlaybackService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Firefly/components/PlayerComponent/PlayerComponentStore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';

class PlayerComponent extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _PlayerComponentState();
}

class _PlayerComponentState extends State<PlayerComponent> {
	@override
	void initState() {
		super.initState();
	}
	void openSongMediaPlayerDialog() {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.fade, 
				duration: Duration(milliseconds: 0),
				child: SongMediaPlayerDialog(
				)
			)
		);
	}
	@override
	Widget build(BuildContext context) {
		return Column(
			children: <Widget>[
				Container(
					height: 2,
					width: MediaQuery.of(context).size.width,
					color: Colors.white
				),
				GestureDetector(
					onTap: openSongMediaPlayerDialog,
					child: Container(
						height: 60,
						width: MediaQuery.of(context).size.width,
						color: Color(0xff242424),
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								GestureDetector(
									onTap: openSongMediaPlayerDialog,
									child: Container(
										width: 60,
										height: 60,
										child: Observer(
											builder: (_) => CachedNetworkImage(
												imageUrl: '${PlayerComponentStoreStore.store.song.image}',
												width: 60,
												height: 60
											)
										)
									)
								),
								Container(
									width: MediaQuery.of(context).size.width - 120,
									height: 60,
									child: Align(
										alignment: Alignment.center,
										child: Row(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: <Widget>[
												Observer(builder: (_) => Text(
														PlayerComponentStoreStore.store.song.title != null ? '${PlayerComponentStoreStore.store.song.title}' : '',
														style: TextStyle(
															color: Colors.white,
															fontFamily: 'Circular',
															fontSize: 13,
															fontWeight: FontWeight.bold
														),
													)
												),
												Observer(builder: (_) => Text(
														PlayerComponentStoreStore.store.song.artist != null ?
														' - ${PlayerComponentStoreStore.store.song.artist}' :
														'',
														style: TextStyle(
															color: Color(0xffbebebe),
															fontFamily: 'Circular',
															fontSize: 13,
															fontWeight: FontWeight.bold
														)
													),
												)
											],
										)
									)
								),
								Container(
									width: 60,
									height: 60,
									child: Observer(
										builder: (_) => RaisedButton(
											elevation: 0,
											color: Color(0xff242424),
											onPressed: () async {
												PlaybackService.togglePlaying();
											},
											child: Icon(
												GlobalPlaybackStore.store.isPlaying ? Foundation.pause : Foundation.play,
												color: Colors.white,
												size: 27,
											)
										),
									)
								),
							]
						)
					)
				)
			]
		);
	}
}