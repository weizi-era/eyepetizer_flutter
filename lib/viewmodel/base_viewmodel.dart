
import 'package:eyepetizer_flutter/viewmodel/base_change_notifier.dart';
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';

abstract class BaseViewModel extends BaseChangeNotifier {

  void refresh() {}

  void loadMore() {}

  void retry() {
    viewState = ViewState.loading;
    notifyListeners();
    refresh();
  }

}
