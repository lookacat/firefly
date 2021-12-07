import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:Firefly/components/TopNavigationComponent/TopNavigationComponent.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/services/SongCachingService/SongCachingStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DebugView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
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
				children: <Widget>[
					TopNavigationComponent(
						color: Colors.red,
						context: context,
						goBackRoute: '/home',
						title: 'Debug Menu',
					),
					RoundedButtonComponent(
						callback: (){
							SongCachingStore.store.deleteLocalStorage();
						},
						minWidth: 250,
						text: 'Delete Cached Tracks',
						margin: EdgeInsets.only(top: 30),
					),
					RoundedButtonComponent(
						callback: (){
							LibraryStore.store.deleteLocalStorage();
						},
						minWidth: 250,
						text: 'Delete Library',
						margin: EdgeInsets.only(top: 15),
					)
				],
			)
		);
	}
}