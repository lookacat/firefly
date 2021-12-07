import 'package:Firefly/models/MainMenuItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:Firefly/navigator/NavigatorStore.dart';

class MainMenuComponent extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => new _MainMenuComponentState();
}

class _MainMenuComponentState extends State<MainMenuComponent> {
	@override
	void initState() {
		super.initState();
	}
	bool get isInDebugMode {
		bool inDebugMode = false;
		assert(inDebugMode = true);
		return inDebugMode;
	}
	Widget getMenuItems(List<MainMenuItem> items) {
		List<Widget> list = new List<Widget>();
		if(isInDebugMode) {
			items.add(
				MainMenuItem(
					title: 'Debug',
					icon: SimpleLineIcons.rocket,
					route: '/debug'
				)
			);
		}
		list.add(
			Container(
				width: ((MediaQuery.of(context).size.width / (items.length + 1)) * 0.5),
				height: 60,
				color: Colors.transparent,
			)
		);
		items.forEach((MainMenuItem item) {
			list.add(
				GestureDetector(
					onTap: () {
						NavigatorStore.store.changeRoute(item.route);
					},
					child: Container(
						width: (MediaQuery.of(context).size.width / (items.length+1)),
						height: 60,
						color: Colors.transparent,
						child: Column(
							children: <Widget>[
								Observer(
									builder: (_) =>Container(
										width: (MediaQuery.of(context).size.width / (items.length+1)),
										height: 30,
										padding: const EdgeInsets.symmetric(vertical: 8),
										child: Icon(item.icon, color: NavigatorStore.store.route == item.route ? Colors.white : Color(0xffb3b3b3), size: 25)
									)
								),
								Observer(
									builder: (_) => Container(
										padding: const EdgeInsets.symmetric(vertical: 7),
										child: Text(
											item.title,
											style: TextStyle(
												color: NavigatorStore.store.route == item.route ? Colors.white : Color(0xffb3b3b3),
												fontFamily: 'Circular',
												fontSize: 12
											)
										)
									)
								)
							],
						)
					)
				),
			);
		});
		list.add(
			Container(
				width: ((MediaQuery.of(context).size.width / (items.length + 1)) * 0.5),
				height: 60,
				color: Colors.transparent,
			)
		);
		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: list
		);
	}
	@override
	Widget build(BuildContext context) {
		return Container(
			height: 60,
			width: MediaQuery.of(context).size.width,
			decoration: const BoxDecoration(
				color: Color(0xff242424),
				border: Border(
					top: BorderSide(width: 1.0, color: Color(0xff121212))
				)
			),
			child: getMenuItems(
				<MainMenuItem>[
					MainMenuItem(
						title: 'Home',
						icon: SimpleLineIcons.home,
						route: '/home'
					),
					MainMenuItem(
						title: 'Search',
						icon: SimpleLineIcons.magnifier,
						route: '/search'
					),
					MainMenuItem(
						title: 'Library',
						icon: SimpleLineIcons.folder_alt,
						route: '/library'
					)
				]
			)
		);
	}
}