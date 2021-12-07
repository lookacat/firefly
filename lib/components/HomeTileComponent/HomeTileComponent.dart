import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

typedef void PressedCallback(String text);

class HomeTileComponent extends StatelessWidget {
	final String imagePath;
	final PressedCallback callback;
	final EdgeInsetsGeometry margin;

	HomeTileComponent({
		@required this.imagePath,
		@required this.callback,
		this.margin
	});

	void onInputChanged(String text) {
		this.callback(text);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: this.margin,
			child: ClipRRect(
				borderRadius: BorderRadius.circular(10.0),
				child: SvgPicture.asset(
					imagePath,
					height: 122.0,
					width: 122.0,
					allowDrawingOutsideViewBox: true
				)
			),
		);
	}
}