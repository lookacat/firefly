import 'package:Firefly/components/Dialogs/BetaDialog/BetaDialog.dart';
import 'package:Firefly/components/Dialogs/RegisterDialog/RegisterDialog.dart';
import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:Firefly/services/UserService/UserService.dart';
import 'package:Firefly/services/UserService/UserServiceStore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/components/NormalTextFieldComponent/NormalTextFieldComponent.dart';
import 'package:page_transition/page_transition.dart';

typedef void CreatedCallback();

class LoginDialog extends StatelessWidget {
	final CreatedCallback onCreated;
	String email = '';
	String password = '';

	LoginDialog({
		this.onCreated
	});

	void onForgotPasswordTab() {

	}
	void onLoginTab(BuildContext context) {
		UserService.login(this.email, this.password).then((bool result) {
			if(result) {
				this.onCreated();
			}else {
				print("error");
			}
		});
	}
	bool onLoggedInCheckBeta(BuildContext context) {
		if(true) {
			Navigator.of(context).push(
				PageTransition(
					type: PageTransitionType.rightToLeftWithFade,
					duration: Duration(milliseconds: 380),
					child: BetaDialog(
						onCreated: () {
							Navigator.of(context).pop();
						},
					)
				)
			);
			return true;
		}
		return false;
	}

	void onRegisterTab(BuildContext context) {
		Navigator.of(context).push(
			PageTransition(
				type: PageTransitionType.rightToLeftWithFade,
				duration: Duration(milliseconds: 380),
				child: RegisterDialog(
					onCreated: (){
						Navigator.of(context).pop();
					}
				)
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color(0xff121212),
			body: SafeArea(
				child: Container(
					child: new Container(
						width: MediaQuery.of(context).size.width,
						height: MediaQuery.of(context).size.height,
						color: Color(0xff121212),
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: <Widget>[
								Container(
									margin: EdgeInsets.only(bottom: 30),
									child: SvgPicture.asset(
										'assets/logo_with_text.svg',
										semanticsLabel: 'Acme Logo',
										width: 160,
									)
								),
								NormalTextFieldComponent(
									margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.04),
									callback: (String text) {
										this.email = text;
									},
									text: 'Email or username...',
									minWidth: 130,
								),
								NormalTextFieldComponent(
									margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.04),
									callback: (String text) {
										this.password = text;
									},
									text: 'Password...',
									minWidth: 130,
								),
								RoundedButtonComponent(
									margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.075),
									callback: () {
										this.onLoginTab(context);
									},
									text: 'login',
									minWidth: 150,
								),
								GestureDetector(
									onTap: onForgotPasswordTab,
									child: Container(
										margin: EdgeInsets.only(top: 60.0),
										child: Text(
											'Forgot password?',
											style: TextStyle(
												fontFamily: 'Circular',
												fontSize: 14,
												color: Color(0xff767676),
											),
										)
									)
								),
								GestureDetector(
									onTap: () {
										onRegisterTab(context);
									},
									child: Container(
										margin: EdgeInsets.only(top: 10.0),
										child: Text(
											'No login? Create an account here',
											style: TextStyle(
												fontFamily: 'Circular',
												fontSize: 14,
												color: Color(0xff767676),
											),
										)
									)
								)
							],
						)
					)
				)
			)
		);
	}
}