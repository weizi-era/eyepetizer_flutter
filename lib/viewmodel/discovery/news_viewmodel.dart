
import 'dart:io';

import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/discovery/news_model.dart';
import 'package:eyepetizer_flutter/viewmodel/base_list_viewmodel.dart';

class NewsViewModel extends BaseListViewModel<NewsItemModel, NewsModel> {
  @override
  NewsModel getModel(Map<String, dynamic> json) => NewsModel.fromJson(json);

  @override
  String getUrl() {
    String deviceModel = Platform.isAndroid ? "Android" : "IOS";
    return "${Url.newsUrl}$deviceModel";
  }

  @override
  String getNextUrl(NewsModel model) {
    String deviceModel = Platform.isAndroid ? "Android" : "IOS";
    return "${model.nextPageUrl}&vc=6030000&deviceModel=$deviceModel";
  }

}