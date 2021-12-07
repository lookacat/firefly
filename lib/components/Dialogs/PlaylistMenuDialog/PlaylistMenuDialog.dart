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

class PlaylistMenuDialog extends StatelessWidget {
	final nameController = TextEditingController();
	final CreatedCallback onCreated;
	final Playlist playlist;

	PlaylistMenuDialog({
		this.onCreated,
		@required this.playlist
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
							title: "${playlist.name}",
						),
						Expanded( 
							child: ListView(
								children: <Widget>[
									ListTile(
										onTap: (){
											try{
												LibraryStore.store.removePlaylist(this.playlist.id);
											} catch(Exception) {}
											Navigator.of(context).pop();
										},
										leading: Container(
											margin: EdgeInsets.only(left: 20),
											child:Icon(FontAwesome5.trash_alt, color: Color(0xfffe4a49), size: 25)
										),
										title: Container(
											margin: EdgeInsets.only(left: 5),
											child: Text(
												'Remove playlist',
												style: new TextStyle(
													color: Color(0xfffe4a49),
													fontFamily: 'Circular',
													fontSize: 16,
													fontWeight: FontWeight.normal
												),
											)
										)
									)
								],
							)
						)
					],
				)
			)
		);
	}
}