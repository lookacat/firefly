import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void UnityAdComponentCreatedCallback(UnityAdController controller);
class UnityAdComponent extends StatefulWidget {
  const UnityAdComponent({
    Key key,
    this.onTextViewCreated,
  }) : super(key: key);

  final UnityAdComponentCreatedCallback onTextViewCreated;

  @override
  State<StatefulWidget> createState() => _UnityAdComponentState();
}

class _UnityAdComponentState extends State<UnityAdComponent> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.example.fireflyapp/UnityBanner',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onTextViewCreated == null) {
      return;
    }
    widget.onTextViewCreated(new UnityAdController._(id));
  }
}

class UnityAdController {
  UnityAdController._(int id)
      : _channel = new MethodChannel('plugins.felix.angelov/textview_$id');

  final MethodChannel _channel;

  Future<void> setText(String text) async {
    assert(text != null);
    return _channel.invokeMethod('setText', text);
  }
}