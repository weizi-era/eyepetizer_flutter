
import 'package:eyepetizer_flutter/http/http_manager.dart';
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/discovery/topic_detail_model.dart';
import 'package:eyepetizer_flutter/utils/toast_util.dart';
import 'package:eyepetizer_flutter/viewmodel/base_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/loading_state_widget.dart';

class TopicDetailViewModel extends BaseViewModel {

  TopicDetailModel topicDetailModel = TopicDetailModel();
  List<TopicDetailItemData> itemList = [];
  final int _id;

  TopicDetailViewModel(this._id);

  @override
  void refresh() {
   HttpManager.getData(
       "${Url.topicsDetailUrl}$_id", success: (json) {
         topicDetailModel = TopicDetailModel.fromJson(json);
         itemList = topicDetailModel.itemList!;
         viewState = ViewState.done;
   }, fail: (e) {
         ToastUtil.showError(e.toString());
         viewState = ViewState.error;
   }, complete: () => notifyListeners());
  }

}