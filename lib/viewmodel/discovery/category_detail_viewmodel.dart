import 'dart:io';

import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/common_item.dart';
import 'package:eyepetizer_flutter/viewmodel/base_list_viewmodel.dart';

class CategoryDetailViewModel extends BaseListViewModel<Item, Issue> {
  int categoryId;

  CategoryDetailViewModel(this.categoryId);

  @override
  Issue getModel(Map<String, dynamic> json) => Issue.fromJson(json);

  @override
  String getUrl() {
    String deviceModel = Platform.isAndroid ? "Android" : "IOS";
    return "${Url.categoryVideoUrl}id=$categoryId&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=$deviceModel";
  }

  @override
  String? getNextUrl(Issue model) {
    String deviceModel = Platform.isAndroid ? "Android" : "IOS";
    return "${model.nextPageUrl!}&udid=d2807c895f0348a180148c9dfa6f2feeac0781b5&deviceModel=$deviceModel";
  }
}
