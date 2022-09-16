
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/discovery/topic_model.dart';
import 'package:eyepetizer_flutter/viewmodel/base_list_viewmodel.dart';

class TopicViewModel extends BaseListViewModel<TopicItemModel, TopicModel> {

  @override
  TopicModel getModel(Map<String, dynamic> json) => TopicModel.fromJson(json);

  @override
  String getUrl() {
    return Url.topicsUrl;
  }

}