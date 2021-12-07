import 'package:applovin/applovin.dart';
import 'package:applovin/banner.dart';
import 'package:Firefly/components/Dialogs/AddToPlaylistDialog/AddToPlaylistDialog.dart';
import 'package:Firefly/components/Dialogs/SongMenuDialog/SongMenuDialog.dart';
import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:Firefly/services/GlobalPlaybackService/GlobalPlaybackStore.dart';
import 'package:Firefly/services/PlaybackService/PlaybackService.dart';
import 'package:Firefly/services/SongCachingService/SongCachingStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/navigator/NavigatorStore.dart';
import 'package:Firefly/models/Song.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Firefly/services/WebApiService/WebApiService.dart';
import 'package:Firefly/components/TopNavigationComponent/TopNavigationComponent.dart';
import 'package:page_transition/page_transition.dart';

class PlaylistView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
	@override
	void initState() {
		super.initState();
	}
	Future<void> onResultTab(Song item) async {
		FocusScope.of(context).unfocus();
		Playlist playlist = selectedPlaylist();
		GlobalPlaybackStore.store.setCurrentPlaylistId(playlist.id);
		await PlaybackService.playSong(item);
		setState(() {
			
		});
	}
	Playlist selectedPlaylist() {
		return NavigatorStore.store.routeParameters['playlist'] != null ? 
			(NavigatorStore.store.routeParameters['playlist'] as Playlist) : Playlist();
	}
	Future<void> onDownloadTab() async {
		Playlist playlist = selectedPlaylist();
		for(Song song in playlist.trackList) {
			if(!SongCachingStore.store.isSongIdCached(song.getId())){
				song.youtubeId = await Api.getYoutubeIdFrom(song.title, song.artist);
				await SongCachingStore.store.downloadAndCacheSong(song);
				setState(() { });
			}
		}
	}
	void openSongMenu(Song item, int index) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.downToUp, 
				duration: Duration(milliseconds: 260),
				child: SongMenuDialog(
					song: item,
					alreadyInPlaylist: true,
					itemIndex: index,
					playlist: this.selectedPlaylist(),
				)
			)
		);
	}
	int adCountForList() {
		int count = ((this.playlistLength() / 10).floor()) - 10;
		if(count < 0) {
			return 0;
		}
		return count;
	}
	bool isIndexAdPlacement(int index) {
		if((index/10).toDouble() == (index/10).floor().toDouble()) {
			return true;
		}
		return false;
	}
	int playlistLength() {
		return (NavigatorStore.store.routeParameters['playlist'] as Playlist).trackList.length;
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height,
			color: Color(0xff121212),
			child: Column(
				children: <Widget>[
					Observer(
						builder: (_) => TopNavigationComponent(
							goBackRoute: '/library',
							context: context,
							color: Color(0xff242424),
							title: NavigatorStore.store.routeParameters['playlist'] != null ? (NavigatorStore.store.routeParameters['playlist'] as Playlist).name : '',
						)
					),
					Expanded(
						child: Observer(
							builder: (_) => ListView.builder(
								physics: const AlwaysScrollableScrollPhysics(),
								itemCount: NavigatorStore.store.routeParameters['playlist'] != null ? this.playlistLength() + 2 + this.adCountForList() : 0,
								itemBuilder: (context, index) {
									if(index == 0) {
										return Container(
											margin: EdgeInsets.only(top: 10, bottom: 10),
											child: RoundedButtonComponent(
												callback: onDownloadTab,
												text: 'Download',
												minWidth: 50,
												margin: EdgeInsets.only(left: 90, right: 90),
											)
										);
									}
									if(index == 1) {
										return BannerView((AppLovinAdListener event) => print(event), BannerAdSize.banner);
									}
									if(isIndexAdPlacement(index) || index-2 > this.playlistLength() - 1) {
										return BannerView((AppLovinAdListener event) => print(event), BannerAdSize.banner);
									}
									final Song item = (NavigatorStore.store.routeParameters['playlist'] as Playlist).trackList[index-2];
									return Observer(
										builder: (_) => ListTile(
											onLongPress: () {
												this.openSongMenu(item, index-1);
											},
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
															text: item.artist,
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
													this.openSongMenu(item, index-1);
												},
												child: Container(
													child: Icon(MaterialIcons.more_vert, color: Color(0xff858689), size: 25)
												)
											),
											onTap: () { 
												onResultTab(item);
											}
										)
									);
								}
							)
						)
					)
				]
			)
		);
	}
}