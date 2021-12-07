import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/components/TopNavigationComponent/TopNavigationComponent.dart';

typedef void CreatedCallback(String playlistId);

class AddNewPlaylistDialog extends StatelessWidget {
	final nameController = TextEditingController();
	final CreatedCallback onCreated;

	AddNewPlaylistDialog({
		this.onCreated
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
							title: 'New Playlist',
						),
						Container(
							margin: EdgeInsets.only(top: 20),
							child: Text(
								'Give your playlist a name.',
								style: new TextStyle(
									color: Colors.white,
									fontFamily: 'Circular',
									fontSize: 16,
									fontWeight: FontWeight.bold
								),
							)
						),
						Container(
							margin: EdgeInsets.only(top: 40, left: 20, right: 20),
							child: TextField(
								style: TextStyle(
									fontSize: 16,
									color: Colors.white,
									fontFamily: 'Circular'
								),
								controller: nameController,
								autofocus: true,
								decoration: InputDecoration(
									focusedBorder: OutlineInputBorder(
										borderSide: BorderSide(color: Color(0xFFF05408), width: 1.0),
									),
									enabledBorder: OutlineInputBorder(
										borderSide: BorderSide(color: Colors.white, width: 1.0),
									),
									hintText: 'Name...',
									hintStyle: TextStyle(
										color: Color(0xffb3b3b3),
										fontFamily: 'Circular'
									)
								),
							)
						),
						RoundedButtonComponent(
							margin: EdgeInsets.only(top: 30),
							callback: (){
								String text = this.nameController.text;
								Playlist playlist = new Playlist(name: text);
								LibraryStore.store.addPlaylist(playlist);
								if(this.onCreated != null) {
									this.onCreated(playlist.id);
								}
								Navigator.of(context).pop();
							},
							text: 'create',
							minWidth: 130,
						)
					],
				)
			)
		);
	}
}