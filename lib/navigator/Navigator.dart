import 'package:Firefly/views/DebugView.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/views/HomeView.dart';
import 'package:Firefly/views/SearchView.dart';
import 'package:Firefly/views/LibraryView.dart';
import 'package:Firefly/views/PlaylistView.dart';
import 'package:page_transition/page_transition.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

class NestedNavigator extends StatelessWidget {
	final String initialRoute;
	final Map<String, WidgetBuilder> routes;

	NestedNavigator({
		@required this.initialRoute,
		@required this.routes,
	});
	
	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			child: Navigator(
				key: navigationKey,
				initialRoute: initialRoute,
				onGenerateRoute: (RouteSettings routeSettings) {
					switch (routeSettings.name) {
						case '/home':
							return PageTransition(type: PageTransitionType.fade, child: HomeView(), duration: Duration(milliseconds: 100));
						case '/search':
							return PageTransition(type: PageTransitionType.fade, child: SearchView(), duration: Duration(milliseconds: 100));
						case '/playlist':
							return PageTransition(type: PageTransitionType.fade, child: PlaylistView(), duration: Duration(milliseconds: 100));
						case '/library':
							return PageTransition(type: PageTransitionType.fade, child: LibraryView(), duration: Duration(milliseconds: 100));
						case '/debug':
							return PageTransition(type: PageTransitionType.fade, child: DebugView(), duration: Duration(milliseconds: 100));
						default:
							return PageTransition(type: PageTransitionType.fade, child: HomeView(), duration: Duration(milliseconds: 100));
					}
				},
			),
			onWillPop: () {
				if(navigationKey.currentState.canPop()) {
					navigationKey.currentState.pop();
					return Future<bool>.value(false);
				}
				return Future<bool>.value(true);
			}
		);
	}
}