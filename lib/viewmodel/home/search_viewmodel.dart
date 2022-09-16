import 'package:eyepetizer_flutter/http/http_manager.dart';
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/utils/toast_util.dart';
import 'package:eyepetizer_flutter/viewmodel/base_change_notifier.dart';
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchViewModel extends BaseChangeNotifier {
  bool hideKeyWord = false;
  bool hideEmpty = true;
  List<Item> dataList = [];
  String? _nextPageUrl;
  // 热搜关键字
  List<String> keyWords = [];
  // 输入的关键字
  String query = '';
  // 搜索结果总共多少
  int total = 0;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  /// 获取热搜关键字
  void getKeyWords() {
    HttpManager.getData(Url.keywordUrl,
        success: (result) {
          List responseList = result as List;
          keyWords = responseList.map((value) {
            return value.toString();
          }).toList();
        },
        fail: (e) {
          ToastUtil.showError(e.toString());
        },
        complete: () => notifyListeners());
  }

  void loadMore({loadMore = true}) {
    String url;
    if (loadMore) {
      if (_nextPageUrl == null) {
        refreshController.loadNoData();
        return;
      }
      url = _nextPageUrl!;
      getData(loadMore, url);
    } else {
      _reset();
      url = Url.searchUrl + query;
      getData(loadMore, url);
    }
  }

  // 搜索数据
  void getData(bool loadMore, String url) {
    HttpManager.getData(url,
        success: (result) {
          Issue issue = Issue.fromJson(result);

          viewState = ViewState.done;
          total = issue.total!;
          if (!loadMore) {
            dataList.clear();
            dataList.addAll(issue.itemList!);
            hideEmpty = dataList.isNotEmpty;
          } else {
            dataList.addAll(issue.itemList!);
            hideEmpty = true;
          }
          dataList.removeWhere((item) {
            return item.data!.cover == null;
          });
          _nextPageUrl = issue.nextPageUrl;
          hideKeyWord = true;

          refreshController.loadComplete();
        },
        fail: (e) {
          ToastUtil.showError(e.toString());
          if (!loadMore) viewState = ViewState.error;
          refreshController.loadFailed();
        },
        complete: () => notifyListeners());
  }

  void _reset() {
    viewState = ViewState.loading;
    notifyListeners();
  }

  void retry() {
    loadMore(loadMore: false);
  }
}
