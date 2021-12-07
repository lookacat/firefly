import 'package:flutter/material.dart';

typedef void PressedCallback();

class RoundedButtonComponent extends StatelessWidget {
	final String text;
	final double minWidth;
	final PressedCallback callback;
	final EdgeInsetsGeometry margin;

	RoundedButtonComponent({
		@required this.text,
		@required this.minWidth,
		@required this.callback,
		this.margin
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: this.margin,
			child: ButtonTheme(
				height: 43,
				minWidth: this.minWidth,
				child: RaisedButton(
					onPressed: this.callback,
					child: Text(
						this.text.toUpperCase(),
						style: TextStyle(
							color: Colors.white,
							fontFamily: 'Circular',
							fontWeight: FontWeight.bold,
							fontSize: 15,
							letterSpacing: 1.5
						)
					),
					color: Color(0xFFF05408),
					padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
					shape: RoundedRectangleBorder(
						borderRadius: new BorderRadius.circular(99.0),
						side: BorderSide(color: Color(0xFFF05408)),
					),
				)
			)
		);
	}
}