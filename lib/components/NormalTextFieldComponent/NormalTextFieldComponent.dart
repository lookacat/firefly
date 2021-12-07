import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void PressedCallback(String text);

class NormalTextFieldComponent extends StatelessWidget {
	final String text;
	final double minWidth;
	final PressedCallback callback;
	final EdgeInsetsGeometry margin;

	NormalTextFieldComponent({
		@required this.text,
		@required this.minWidth,
		@required this.callback,
		this.margin
	});

	void onInputChanged(String text) {
		this.callback(text);
	}

	@override
	Widget build(BuildContext context) {
		final double width = MediaQuery.of(context).size.width;
		return Container(
			margin: this.margin,
			width: width - (width*0.1),
			child: Container(
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(4.0),
					color: Color(0xff323030)
				),
				padding: const EdgeInsets.symmetric(
					vertical: 2.5,
					horizontal: 20.0
				),
				child: TextField(
					onChanged: onInputChanged,
					style: new TextStyle(
						color: Colors.white,
						fontFamily: 'Circular',
						fontSize: 17,
					),
					autocorrect: false,
					enableSuggestions: false,
					decoration: InputDecoration(
						border: InputBorder.none,
						hintText: this.text,
						hintStyle: new TextStyle(
							color: Color(0xffafafaf),
							fontFamily: 'Circular',
							fontSize: 17
						)
					),
				),
			),
		);
	}
}