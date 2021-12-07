import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:Firefly/services/UserService/UserService.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/components/NormalTextFieldComponent/NormalTextFieldComponent.dart';

typedef void CreatedCallback();

class RegisterDialog extends StatelessWidget {
	final CreatedCallback onCreated;
	String email = '';
	String password = '';
	String firstName = '';
	String lastName = '';

	RegisterDialog({
		this.onCreated
	});

	void onForgotPasswordTab() {

	}

	void onLoginTab(BuildContext context) {
		Navigator.of(context).pop();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Color(0xff121212),
			body: SafeArea(
				child: Flex(
					direction: Axis.horizontal,
					children: [
						Expanded(
							child: new Container(
								height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom*0.5,
								width: MediaQuery.of(context).size.width,
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
											margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.02),
											callback: (String text) {
												this.firstName = text;
											},
											text: 'First Name...',
											minWidth: 130,
										),
										NormalTextFieldComponent(
											margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.02),
											callback: (String text) {
												this.lastName = text;
											},
											text: 'Last Name...',
											minWidth: 130,
										),
										NormalTextFieldComponent(
											margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.02),
											callback: (String text) {
												this.email = text;
											},
											text: 'Email or username...',
											minWidth: 130,
										),
										NormalTextFieldComponent(
											margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.02),
											callback: (String text) {
												this.password = text;
											},
											text: 'Password...',
											minWidth: 130,
										),
										RoundedButtonComponent(
											margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.075),
											callback: () {
												UserService.register(this.email, this.password, this.firstName, this.lastName).then((Map<String, dynamic> result) {
													bool success = result["success"] as bool;
													print(result);
													if(success) {
														this.onCreated();
													}else {
														print("error");
													}
												});
												// print wrong password else
											},
											text: 'sign up',
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
												onLoginTab(context);
											},
											child: Container(
												margin: EdgeInsets.only(top: 10.0),
												child: Text(
													'Go back to login',
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
					]
				)
			)
		);
	}
}