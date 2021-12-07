import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/models/Song.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/components/Dialogs/AddNewPlaylistDialog/AddNewPlaylistDialog.dart';
import 'package:Firefly/components/TopNavigationComponent/TopNavigationComponent.dart';
import 'package:page_transition/page_transition.dart';

class AddToPlaylistDialog extends StatelessWidget {
	final Song song;
	final Function onCreated;

	AddToPlaylistDialog({
		@required this.song,
		@required this.onCreated
	});

	onNewPlaylistTab(BuildContext context) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.downToUp, 
				duration: Duration(milliseconds: 360),
				child: AddNewPlaylistDialog(
					onCreated: (String id){
						LibraryStore.store.addTrackToPlaylist(song, id);
						Navigator.of(context).pop();
					},
				)
			)
		);
	}
	onResultTab(Playlist item, BuildContext context) {
		LibraryStore.store.addTrackToPlaylist(song, item.id);
		Navigator.of(context).pop();
		this.onCreated();
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			child: new Container(
				width: MediaQuery.of(context).size.width,
				height: MediaQuery.of(context).size.height,
				color: Color(0xff121212),
				child: Column(
					children: <Widget>[
						TopNavigationComponent(
							context: context,
							color: Color(0xff121212),
							title: 'Add to Playlist',
						),
						Expanded(
							child: Observer(
								builder: (_) => ListView.builder(
									physics: const AlwaysScrollableScrollPhysics(),
									itemCount: LibraryStore.store.playlists.length + 1,
									itemBuilder: (context, index) {
										if(index == 0) {
											return Container(
												margin: EdgeInsets.only(bottom: 8),
												child: ListTile(
													leading: Image(
														image: AssetImage('assets/new_playlist.png')
													),
													title: Text(
														'New Playlist',
														style: new TextStyle(
															color: Colors.white,
															fontFamily: 'Circular',
															fontSize: 16
														),
													),
													onTap: () { 
														onNewPlaylistTab(context);
													},
												)
											);
										}
										final Playlist item = LibraryStore.store.playlists[index-1];
										return ListTile(
											leading: Image(
												image: AssetImage('assets/default_playlist.png')
											),
											title: Text(
												item.name,
												style: new TextStyle(
													color: Colors.white,
													fontFamily: 'Circular',
													fontSize: 16
												),
											),
											subtitle: Text(
												'${item.trackList.length} Tracks',
												style: new TextStyle(
													color: Color(0xffb6b6b6),
													fontFamily: 'Circular',
													fontSize: 14
												),
											),
											onTap: () { 
												onResultTab(item, context);
											},
										);
									}
								)
							)
						),
					],
				)
			)
		);
	}
}