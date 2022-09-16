
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/viewmodel/base_list_viewmodel.dart';

class HotListViewModel extends BaseListViewModel<Item, Issue> {
  String url;

  HotListViewModel(this.url);

  @override
  Issue getModel(Map<String, dynamic> json) => Issue.fromJson(json);

  @override
  String getUrl() {
    return url;
  }
}