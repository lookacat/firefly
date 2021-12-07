import 'package:Firefly/components/Dialogs/ImportPlaylistDialog/ImportPlaylistDialog.dart';
import 'package:Firefly/components/Dialogs/PlaylistMenuDialog/PlaylistMenuDialog.dart';
import 'package:Firefly/services/SpotifyImportService/SpotifyImportService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Firefly/navigator/NavigatorStore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/components/Dialogs/AddNewPlaylistDialog/AddNewPlaylistDialog.dart';
import 'package:page_transition/page_transition.dart';


class LibraryPlaylistComponent extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _LibraryPlaylistComponentState();
}

class _LibraryPlaylistComponentState extends State<LibraryPlaylistComponent> {
	@override
	void initState() {
		super.initState();
	}
	void onResultTab(Playlist item) {
		Map<String, dynamic> parameters = new Map<String, dynamic>();
		parameters['playlist'] = item;
		NavigatorStore.store.changeRoute('/playlist', parameters: parameters);
	}

	void onImportPlaylistTab(BuildContext context) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.downToUp, 
				duration: Duration(milliseconds: 360),
				child: ImportPlaylistDialog(
					onCreated: () {
						setState(() {
						});
					},
				)
			)
		);
	}

	void onNewPlaylistTab(BuildContext context) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.downToUp, 
				duration: Duration(milliseconds: 360),
				child: AddNewPlaylistDialog()
			)
		);
	}
	void openPlaylistMenu(Playlist playlist, int index) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.downToUp, 
				duration: Duration(milliseconds: 260),
				child: PlaylistMenuDialog(
					playlist: playlist
				)
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return Column(
			children: <Widget>[
				Expanded(
					child: SizedBox(
						child: Observer(
							builder: (_) => ListView.builder(
								physics: const AlwaysScrollableScrollPhysics(),
								itemCount: LibraryStore.store.playlists.length + 2,
								itemBuilder: (context, index) {
									if(index == 0) {
										return Container(
											margin: EdgeInsets.only(bottom: 16, top: 20),
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
									}else if(index == 1) {
										return Container(
											margin: EdgeInsets.only(bottom: 8),
											child: ListTile(
												leading: Image(
													image: AssetImage('assets/new_playlist.png')
												),
												title: Text(
													'Import Playlist',
													style: new TextStyle(
														color: Colors.white,
														fontFamily: 'Circular',
														fontSize: 16
													),
												),
												onTap: () { 
													onImportPlaylistTab(context);
												},
											)
										);
									}
									final Playlist item = LibraryStore.store.playlists[index-2];
									return ListTile(
										onLongPress: () {
											this.openPlaylistMenu(item, index-2);
										},
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
											onResultTab(item);
										},
									);
								}
							)
						)
					)
				)
			],
		);
	}
}