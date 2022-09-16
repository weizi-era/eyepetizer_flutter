
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/model/issue_model.dart';
import 'package:eyepetizer_flutter/viewmodel/base_list_viewmodel.dart';


class HomePageViewModel extends BaseListViewModel<Item, IssueEntity> {

  List<Item>? bannerList = [];

  @override
  IssueEntity getModel(Map<String, dynamic> json) => IssueEntity.fromJson(json);

  @override
  String getUrl() => Url.feedUrl;



  @override
  void getData(List<Item>? list) {
    bannerList = list;
    itemList?.clear();
    itemList?.add(Item());
  }

  @override
  void removeUselessData(List<Item>? list) {
    list?.removeWhere((element) => element.type == "banner2");
  }

  @override
  void doExtraAfterRefresh() async {
    await loadMore();
  }

}
