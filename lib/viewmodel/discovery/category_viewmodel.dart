import 'package:eyepetizer_flutter/http/http_manager.dart';
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/discovery/category_model.dart';
import 'package:eyepetizer_flutter/utils/toast_util.dart';
import 'package:eyepetizer_flutter/viewmodel/base_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';

class CategoryViewModel extends BaseViewModel {
  List<CategoryModel> list = [];

  @override
  void refresh() async {
    HttpManager.getData(Url.categoryUrl,
        success: (result) {
          list = (result as List)
              .map((json) => CategoryModel.fromJson(json))
              .toList();
          viewState = ViewState.done;
        },
        fail: (e) {
          viewState = ViewState.error;
          ToastUtil.showError(e.toString());
        },
        complete: () => notifyListeners());
  }
}
