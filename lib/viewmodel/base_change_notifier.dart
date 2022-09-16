
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';
import 'package:flutter/material.dart';

class BaseChangeNotifier extends ChangeNotifier {

  ViewState viewState = ViewState.loading;

  //页面销毁则不发送通知
  bool _dispose = false;

  @override
  void dispose() {
    super.dispose();
    _dispose = true;
  }

  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }
}