import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackService.dart';
import 'package:Firefly/services/PlaybackService/PlaybackService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:Firefly/services/WebApiService/WebApiService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Firefly/models/Song.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Firefly/services/SongCachingService/SongCachingStore.dart';
import 'package:Firefly/components/PlayerComponent/PlayerComponentStore.dart';
import 'package:Firefly/components/Dialogs/AddToPlaylistDialog/AddToPlaylistDialog.dart';
import 'package:page_transition/page_transition.dart';

class SearchView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _SearchViewState();
}

class _SearchViewState extends State<SearchView> with AutomaticKeepAliveClientMixin {
	List<Song> results = new List<Song>();
	static const platform = const MethodChannel('flutter.native/helper');

	@override
	void initState() {
		super.initState();
	}
	onInputChanged(String text) {
		Api.getGeniusSearchResults(text).then((List<Song> temp) {
			setState(() {
				results = temp;
			});
			print("done $text");
		});
		print("loading new $text");
	}
	onResultTab(Song song) async {
		FocusScope.of(context).unfocus();
		await PlaybackService.playSong(song);
		try {
			platform.invokeMethod('videoAd');
		} on PlatformException catch (e) {
			print("Failed to Invoke: '${e.message}'.");
		}
		setState(() {
			
		});
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height,
			color: Color(0xff121212),
			child: Column(
				children: <Widget>[
					Container(
						color: Color(0xff323030),
						padding: const EdgeInsets.symmetric(
							vertical: 5.0,
							horizontal: 20.0
						),
						child: TextField(
							onChanged: onInputChanged,
							style: new TextStyle(
								color: Colors.white,
								fontFamily: 'Circular',
								fontSize: 16
							),
							decoration: InputDecoration(
								border: InputBorder.none,
								hintText: 'Suche...',
								hintStyle: new TextStyle(
									color: Color(0xffafafaf),
									fontFamily: 'Circular',
									fontSize: 16
								)
							),
						),
					),
					Expanded(
						child: ListView.builder(
							physics: const AlwaysScrollableScrollPhysics(),
							itemCount: results.length,
							itemBuilder: (context, index) {
								final Song item = results[index];
								return Observer(
									builder: (_) => ListTile(
										leading: CachedNetworkImage(
											imageUrl: item.image,
                      width: 50,
                      height: 50
										),
										title: Text(
											item.title,
											style: new TextStyle(
												color: Colors.white,
												fontFamily: 'Circular',
												fontSize: 16
											),
										),
										subtitle: RichText(
											text: TextSpan(
												children: [
													SongCachingStore.store.isSongIdCached(item.getId()) ? WidgetSpan(
														child: Icon(EvilIcons.arrow_down, color: Color(0xFFF05408), size: 20),
													) : TextSpan(),
													TextSpan(
														text: (SongCachingStore.store.isSongIdCached(item.title + item.artist) ? ' ' : '' ) + item.artist,
														style: new TextStyle(
															color: Color(0xffb6b6b6),
															fontFamily: 'Circular',
															fontSize: 14
														),
													)
												]
											)
										),
										trailing: GestureDetector(
											onTap: () {
												Navigator.of(context).push(
													PageTransition(
														type: PageTransitionType.rightToLeft, 
														duration: Duration(milliseconds: 360),
														child: AddToPlaylistDialog(song: item)
													)
												);
											},
											child: Container(
												child: Icon(MaterialIcons.more_vert, color: Color(0xff858689), size: 25)
											)
										),
										onTap: () { 
											onResultTab(item);
										},
									)
								);
							}
						)
					)
				]
			)
		);
	}
	@override
	bool get wantKeepAlive => true;
}