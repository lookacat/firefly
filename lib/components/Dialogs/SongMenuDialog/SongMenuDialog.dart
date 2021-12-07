import 'package:Firefly/components/Dialogs/AddToPlaylistDialog/AddToPlaylistDialog.dart';
import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/models/Song.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/services/SpotifyImportService/SpotifyImportService.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/components/TopNavigationComponent/TopNavigationComponent.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

typedef void CreatedCallback();

class SongMenuDialog extends StatelessWidget {
	final nameController = TextEditingController();
	final CreatedCallback onCreated;
	final Song song;
	final bool alreadyInPlaylist;
	final int itemIndex;
	final Playlist playlist;

	SongMenuDialog({
		this.onCreated,
		@required this.song,
		@required this.alreadyInPlaylist,
		this.itemIndex,
		this.playlist
	});

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
							title: "${song.title} - ${song.artist}",
						),
						Expanded( 
							child: ListView(
								children: <Widget>[
									ListTile(
										onTap: (){
											Navigator.of(context).push(
												PageTransition(
													type: PageTransitionType.downToUp, 
													duration: Duration(milliseconds: 300),
													child: AddToPlaylistDialog(
														song: song,
														onCreated: () {
															Navigator.of(context).pop();
														},
													)
												)
											);
										},
										leading: Container(
											margin: EdgeInsets.only(left: 20),
											child:Icon(FontAwesome.plus, color: Color(0xff7bc043), size: 25)
										),
										title: Container(
											margin: EdgeInsets.only(left: 5),
											child: Text(
												this.alreadyInPlaylist ? 'Add to another playlist' : 'Add to playlist',
												style: new TextStyle(
													color: Color(0xff7bc043),
													fontFamily: 'Circular',
													fontSize: 16,
													fontWeight: FontWeight.normal
												),
											)
										)
									),
									this.alreadyInPlaylist ? ListTile(
										onTap: (){
											LibraryStore.store.removeTrackFromPlaylist(this.itemIndex, this.playlist.id);
											Navigator.of(context).pop();
										},
										leading: Container(
											margin: EdgeInsets.only(left: 20),
											child:Icon(FontAwesome5.trash_alt, color: Color(0xfffe4a49), size: 25)
										),
										title: Container(
											margin: EdgeInsets.only(left: 5),
											child: Text(
												'Remove from playlist',
												style: new TextStyle(
													color: Color(0xfffe4a49),
													fontFamily: 'Circular',
													fontSize: 16,
													fontWeight: FontWeight.normal
												),
											)
										)
									) : Container()
								],
							)
						)
					],
				)
			)
		);
	}
}