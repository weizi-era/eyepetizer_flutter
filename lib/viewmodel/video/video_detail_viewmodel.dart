import 'package:eyepetizer_flutter/http/http_manager.dart';
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/utils/toast_util.dart';
import 'package:eyepetizer_flutter/viewmodel/base_change_notifier.dart';
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';

class ViewDetailViewModel extends BaseChangeNotifier {
  List<Item>? itemList = [];

  late int _videoId;

  void loadVideoData(int id) {
    _videoId = id;
    HttpManager.getData("${Url.videoRelatedUrl}$id",
        success: (json) {
          Issue issue = Issue.fromJson(json);
          itemList = issue.itemList;
          viewState = ViewState.done;
        },
        fail: (e) {
          ToastUtil.showError(e.toString());
          viewState = ViewState.error;
        },
        complete: () => notifyListeners());
  }

  void retry() {
    viewState = ViewState.loading;
    notifyListeners();
    loadVideoData(_videoId);
  }
}
