import 'package:Firefly/components/RoundedButtonComponent/RoundedButtonComponent.dart';
import 'package:Firefly/services/UserService/UserService.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:Firefly/components/NormalTextFieldComponent/NormalTextFieldComponent.dart';

typedef void CreatedCallback();

class BetaDialog extends StatelessWidget {
	final CreatedCallback onCreated;
	String email = '';
	String password = '';

	BetaDialog({
		this.onCreated
	});

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
										'assets/logo_with_text_beta.svg',
										semanticsLabel: 'Acme Logo',
										width: 160,
									)
								),
								NormalTextFieldComponent(
									margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.04),
									callback: (String text) {
										this.password = text;
									},
									text: 'Enter Beta Code...',
									minWidth: 130,
								),
								RoundedButtonComponent(
									margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom) * 0.075),
									callback: () {
										/*UserService.login(this.email, this.password).then((Map<String, dynamic> result) {
											bool success = result["success"] as bool;
											print(result);
											if(success) {
												this.onCreated();
											}else {
												print("error");
											}
										});*/
										// print wrong password else
									},
									text: 'verify',
									minWidth: 150,
								)
							],
						)
					)
				)
			)
		);
	}
}