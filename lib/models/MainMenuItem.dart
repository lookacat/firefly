import 'package:flutter/widgets.dart';

class MainMenuItem {
	IconData icon;
	String route;
	String title;
	MainMenuItem({
		@required this.route,
		@required this.icon,
		@required this.title
	});
}