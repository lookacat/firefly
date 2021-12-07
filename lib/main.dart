import 'package:applovin/applovin.dart';
import 'package:applovin/banner.dart';
import 'package:Firefly/components/Dialogs/LoginDialog/LoginDialog.dart';
import 'package:Firefly/components/MainMenuComponent/MainMenuComponent.dart';
import 'package:Firefly/services/LibraryService/LibraryStore.dart';
import 'package:Firefly/services/PlaybackService/PlaybackService.dart';
import 'package:Firefly/services/SongCachingService/SongCachingStore.dart';
import 'package:Firefly/services/UserService/UserService.dart';
import 'package:Firefly/services/UserService/UserServiceStore.dart';
import 'package:Firefly/views/HomeView.dart';
import 'package:Firefly/views/SearchView.dart';
import 'package:Firefly/navigator/Navigator.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/components/PlayerComponent/PlayerComponent.dart';
import 'package:Firefly/services/PythonDownloadService/PythonDownloadService.dart';
import 'package:Firefly/services/YoutubePlaybackService/YoutubePlaybackService.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:page_transition/page_transition.dart';

import 'navigator/NavigatorStore.dart';

void main(){
	runApp(new MyApp());
}

class MyApp extends StatelessWidget {
	MyApp();
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Flutter Demo',
			theme: new ThemeData(
				primarySwatch: Colors.grey,
			),
			home: new MyHomePage(title: 'Python Console'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	MyHomePage({Key key, this.title}) : super(key: key);
	final String title;

	@override
	_MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
	final zones = [
    'vzbd76deb0b7894582b1',
    'vz5294dd3ccc0d4b148a'
	];
	void showLoginScreen(BuildContext context) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.fade, 
				duration: Duration(milliseconds: 0),
				child: LoginDialog(
					onCreated: (){
						Navigator.of(context).pop();
					}
				)
			)
		);
	}
	@override
	void initState() {
		AppLovin.init();
		super.initState();

		UserServiceStore.store.loadLocalStorage().then((_) {
			/*UserService.sessionVerify(UserServiceStore.store.user.session).then((bool result){
				print(":__________________:::_______________________________:::__________________________:::");
				print(UserServiceStore.store.user.session);
				if(!result) {
					Future.delayed(Duration(milliseconds: 100)).then((_) {
						this.showLoginScreen(context);
					});
				}
			});*/
		});
		
		SongCachingStore.store.loadLocalStorage();
		LibraryStore.store.loadLocalStorage();
		YoutubePlaybackService.initializeAndBindEvents();
		PythonDownloadService.initializeAndBindEvents();
		PlaybackService.startAudioService();
	}
	bool showTopBannerAd(){
		if(NavigatorStore.store.route == '/playlist' || NavigatorStore.store.route == '/search') {
			return false;
		}
		return true;
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color(0xff121212),
			resizeToAvoidBottomInset : false,
			body: Observer(
				builder: (_) => Stack(
					children: <Widget>[
						showTopBannerAd() ? Container(
							color: Color(0xff242424),
							height: 100
						): Container(),
						SafeArea(
							child: Stack(
								children: <Widget>[
									showTopBannerAd() ? Positioned(
										top: 0,
										left: 0,
										right: 0,
										child: BannerView((AppLovinAdListener event) => print(event), BannerAdSize.leader)
									) : Container(),
									Positioned(
										top: showTopBannerAd() ? 50: 0,
										left: 0,
										right: 0,
										bottom: 0,
										child: Container(
											color: Color(0xFFF05408),
											height: 2
										)
									),
									Positioned(
										left: 0,
										right: 0,
										bottom: 120,
										top: showTopBannerAd() ? 52 : 2,
										child: NestedNavigator(
											initialRoute: '/home',
											routes: {
												'/home': (context) => HomeView(),
												'/search': (context) => SearchView(),
											}
										)
									),
									Positioned(
										bottom: 60,
										left: 0,
										child: PlayerComponent(),
									),
									Positioned(
										bottom: 0,
										left: 0,
										child: MainMenuComponent(),
									)
								],
							)
						)
					]
				)
			)
		);
	}
}
