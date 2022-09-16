
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/viewmodel/base_list_viewmodel.dart';

class FollowViewModel extends BaseListViewModel<Item, Issue> {
  @override
  Issue getModel(Map<String, dynamic> json) {
    return Issue.fromJson(json);
  }

  @override
  String getUrl() {
    return Url.followUrl;
  }
  
}