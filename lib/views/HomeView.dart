import 'package:Firefly/components/HomePlaylistTileComponent/HomePlaylistTileComponent.dart';
import 'package:Firefly/components/HomeTileComponent/HomeTileComponent.dart';
import 'package:Firefly/components/Utils/CustomScrollBehavior.dart';
import 'package:Firefly/models/Playlist.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
	@override
	void initState() {
		super.initState();
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height,
			color: Color(0xff121212),
			child: Column(
				children: [
					Container(
						height: 60,
						alignment: Alignment.bottomLeft,
						padding: EdgeInsets.only(left: 17, bottom: 5),
						child: Container(
							padding: EdgeInsets.only(
								bottom: 5,
							),
							decoration: BoxDecoration(
								border: Border(
									bottom: BorderSide(
										color: Color(0xFFF05408),
										width: 2.0,
									)
								)
							),
							child: Text(
								'Welcome, Paul',
								style: TextStyle(
									color: Colors.white,
									fontFamily: 'Circular',
									fontSize: 22,
									fontWeight: FontWeight.bold,
								),
							),
						)
					),
					Container(
						height: 60,
						alignment: Alignment.bottomLeft,
						padding: EdgeInsets.only(left: 17, bottom: 5),
						child: Container(
							child: Text(
								'Your Playlists',
								style: TextStyle(
									color: Colors.white,
									fontFamily: 'Circular',
									fontSize: 20,
									fontWeight: FontWeight.bold,
								),
							),
						)
					),
					ConstrainedBox(
						constraints: new BoxConstraints(
							minHeight: 100.0,
							maxHeight: 100.0,
							minWidth: MediaQuery.of(context).size.width,
							maxWidth: MediaQuery.of(context).size.width
						),
						child: ScrollConfiguration(
							behavior: CustomScrollBehavior(),
							child: Observer(
								builder: (_) => ListView.builder(
									shrinkWrap: true,
									physics: const AlwaysScrollableScrollPhysics(),
									scrollDirection: Axis.horizontal,
									itemCount: LibraryStore.store.playlists.length,
									itemBuilder: (context, index) {
										final Playlist item = LibraryStore.store.playlists[index];
										return HomePlaylistTileComponent(playlist: item);
									}
								)
							)
						)
					),
					Container(
						height: 60,
						alignment: Alignment.bottomLeft,
						padding: EdgeInsets.only(left: 17, bottom: 5),
						child: Container(
							child: Text(
								'Quick Features',
								style: TextStyle(
									color: Colors.white,
									fontFamily: 'Circular',
									fontSize: 20,
									fontWeight: FontWeight.bold,
								),
							),
						)
					),
					ConstrainedBox(
						constraints: new BoxConstraints(
							minHeight: 140.0,
							maxHeight: 140.0,
						),
						child: ScrollConfiguration(
							behavior: CustomScrollBehavior(),
							child: ListView(
								shrinkWrap: true,
								physics: const AlwaysScrollableScrollPhysics(),
								scrollDirection: Axis.horizontal,
								children: <Widget>[
									HomeTileComponent(
										margin: EdgeInsets.only(left: 7, right: 7),
										imagePath: 'assets/tiles/import.svg',
										callback: (_){},
									),
									HomeTileComponent(
										margin: EdgeInsets.only(left: 7, right: 7),
										imagePath: 'assets/tiles/listen_together.svg',
										callback: (_){},
									),
									HomeTileComponent(
										margin: EdgeInsets.only(left: 7, right: 7),
										imagePath: 'assets/tiles/most_heared.svg',
										callback: (_){},
									),
								],
							)
						)
					)
				]
			)
		);				
	}
}