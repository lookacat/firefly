import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Firefly/components/PlayerComponent/PlayerComponentStore.dart';
import 'package:Firefly/components/TopNavigationComponent/TopNavigationComponent.dart';
import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackStore.dart';
import 'package:Firefly/services/PlaybackService/PlaybackService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SongMediaPlayerDialog extends StatefulWidget {
	SongMediaPlayerDialog({Key key}) : super(key: key);

	@override
	_SongMediaPlayerDialogState createState() => _SongMediaPlayerDialogState();
}

class _SongMediaPlayerDialogState extends State<SongMediaPlayerDialog> {
	@override
	void initState(){
		super.initState();
		SystemChrome.setPreferredOrientations([
			DeviceOrientation.portraitUp,
			DeviceOrientation.portraitDown,
		]);
	}
	String toMinuteDuration(double seconds) {
		String twoDigits(int n) {
			if (n >= 10) return "$n";
			return "0$n";
		}

		String twoDigitMinutes = twoDigits((seconds ~/ 60).toInt().remainder(60));
		String twoDigitSeconds = twoDigits(seconds.toInt().remainder(60));
		return "$twoDigitMinutes:$twoDigitSeconds";
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Container(
				color: Color(0xff121212),
				child: SafeArea(
					child: Observer(
						builder: (_) => Column(
							children: <Widget>[
								TopNavigationComponent(
									title: '',
									color: Colors.transparent,
									context: context,
								),
								Container(
									margin: EdgeInsets.only(top: 20),
									child: CachedNetworkImage(
										imageUrl: '${PlayerComponentStoreStore.store.song.image}',
										width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.2),
										height: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.2)
									)
								),
								Row(
									children: <Widget>[
										Container(
											width: MediaQuery.of(context).size.width * 0.2,
										),
										Container(
											width: MediaQuery.of(context).size.width * 0.6,
											margin: EdgeInsets.only(bottom: 10),
											child: Column(
												children: <Widget>[
													Container(
														margin: EdgeInsets.only(bottom: 3, top: 20),
														child: Text(
															'${PlayerComponentStoreStore.store.song.title}',
															textAlign: TextAlign.center,
															style: TextStyle(
																color: Colors.white,
																fontFamily: 'Circular',
																fontSize: 16,
																fontWeight: FontWeight.bold
															),
														)
													),
													Text(
														'${PlayerComponentStoreStore.store.song.artist}',
														textAlign: TextAlign.center,
														style: TextStyle(
															color: Color(0xffb5b9bc),
															fontFamily: 'Circular',
															fontSize: 15
														),
													)
												],
											)
										),
										Container(
											width: MediaQuery.of(context).size.width * 0.2,
										)
									],
								),
								Row(
									children: <Widget>[
										Container(
											width: MediaQuery.of(context).size.width * 0.175,
											child: Text(
												toMinuteDuration(PlayerComponentStoreStore.store.position / 1000000),
												textAlign: TextAlign.center,
												style: TextStyle(
													color: Color(0xffb5b9bc),
													fontFamily: 'Circular',
												),
											)
										),
										Container(
											height: 50,
											width: MediaQuery.of(context).size.width * 0.65,
											child: SliderTheme(
												data: SliderTheme.of(context).copyWith(
													activeTrackColor: Colors.white,
													inactiveTrackColor: Color(0xff1c272b),
													trackHeight: 3.0,
													thumbColor: Colors.white,
													thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
													overlayColor: Colors.purple.withAlpha(32),
													overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
												),
												child: Slider(
													value: (PlayerComponentStoreStore.store.position / 1000000),
													min: 0.0,
													max: (PlayerComponentStoreStore.store.duration / 1000000),
													onChanged: (double newValue) {
														setState(() {
															AudioService.seekTo((newValue * 1000).toInt());
														});
													},
												)
											)
										),
										Container(
											width: MediaQuery.of(context).size.width * 0.175,
											child: Text(
												toMinuteDuration(PlayerComponentStoreStore.store.duration / 1000000),
												textAlign: TextAlign.center,
												style: TextStyle(
													color: Color(0xffb5b9bc),
													fontFamily: 'Circular',
													fontWeight: FontWeight.w100
												),
											)
										)
									],
								),
								Row(
									children: <Widget>[
										GestureDetector(
											onTap: (){},
											child: Container(
												width: MediaQuery.of(context).size.width / 5,
											)
										),
										GestureDetector(
											onTap: (){
												AudioService.skipToPrevious();
											},
											child: Container(
												width: MediaQuery.of(context).size.width / 5,
												child: Icon(Ionicons.ios_skip_backward, color: Colors.white)
											)
										),
										GestureDetector(
											onTap: (){
												PlaybackService.togglePlaying();
											},
											child: Container(
												width: MediaQuery.of(context).size.width / 5,
												child: Icon(
													GlobalPlaybackStore.store.isPlaying ? Foundation.pause : Foundation.play,
													color: Colors.white,
													size: 65,
												)
											)
										),
										GestureDetector(
											onTap: (){
												AudioService.skipToNext();
											},
											child: Container(
												width: MediaQuery.of(context).size.width / 5,
												child: Icon(Ionicons.ios_skip_forward, color: Colors.white)
											)
										),
										GestureDetector(
											onTap: (){},
											child: Container(
												width: MediaQuery.of(context).size.width / 5,
											)
										)
									],
								)
							],
						)
					)
				)
			)
		);
	}
}