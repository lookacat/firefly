import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Firefly/components/LibraryPlaylistComponent/LibraryPlaylistComponent.dart';

class LibraryView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
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
								'Your Library',
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
						child: Expanded(
							child: LibraryPlaylistComponent()
						)
					)
				],
			)
		);
	}
}