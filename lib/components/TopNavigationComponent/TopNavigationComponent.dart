import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Firefly/navigator/NavigatorStore.dart';

class TopNavigationComponent extends StatefulWidget {
	final String goBackRoute;
	final String title;
	final Color color;
	final BuildContext context;
	TopNavigationComponent({
		this.goBackRoute,
		this.title='',
		@required this.color,
		@required this.context
	});
	@override
	State<StatefulWidget> createState() => new _TopNavigationComponentState(goBackRoute: this.goBackRoute, title: this.title, color: this.color, context: this.context);
}

class _TopNavigationComponentState extends State<TopNavigationComponent> {
	final String goBackRoute;
	final String title;
	final Color color;
	final BuildContext context;

	_TopNavigationComponentState({
		@required this.goBackRoute,
		@required this.title,
		@required this.color,
		@required this.context
	});

	@override
	void initState() {
		super.initState();
	}
	void goBack() {
		if(this.goBackRoute == null || this.goBackRoute == '') {
			Navigator.of(context).pop();
			return;
		}
		NavigatorStore.store.changeRoute(this.goBackRoute);
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			width: MediaQuery.of(context).size.width,
			height: 50,
			color: this.color,
			child: Row(
				children: <Widget>[
					GestureDetector(
						onTap: () {
							goBack();
						},
						child: Container(
							width: 35,
							height: 50,
							color: Colors.transparent,
							child: Icon(SimpleLineIcons.arrow_left, color: Colors.white, size: 17)
						)
					),
					Container(
						width: MediaQuery.of(context).size.width - 35*2,
						height: 50,
						color: Colors.transparent,
						child: Center(
							child: Text(
								this.title,
								textAlign: TextAlign.center,
								style: TextStyle(
									color: Colors.white,
									fontFamily: 'Circular',
									fontSize: 15,
									fontWeight: FontWeight.bold
								),
							)
						),
					),
					Container(
						width: 35,
						height: 50,
						color: Colors.transparent
					)
				],
			)
		);
	}
}