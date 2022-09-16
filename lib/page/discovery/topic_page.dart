import 'package:animations/animations.dart';
import 'package:eyepetizer_flutter/model/discovery/topic_model.dart';
import 'package:eyepetizer_flutter/page/discovery/topic_detail_page.dart';
import 'package:eyepetizer_flutter/state/base_list_state.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/viewmodel/discovery/topic_viewmodel.dart';
import 'package:flutter/material.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState
    extends BaseListState<TopicItemModel, TopicViewModel, TopicPage> {
  @override
  Widget getContentChild(TopicViewModel model) {
    return ListView.builder(
      itemCount: model.itemList!.length,
      itemBuilder: (context, index) {
        return OpenContainer(
          closedBuilder: (context, action) {
            return _topicItemWidget(model.itemList![index]);
          },
          openBuilder: (context, action) {
            return TopicDetailPage(detailId: model.itemList![index].data!.id!);
          },
        );
      },
    );
  }

  @override
  TopicViewModel get viewModel => TopicViewModel();

  Widget _topicItemWidget(TopicItemModel item) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: cacheImage(item.data!.image!,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 200),
      ),
    );
  }
}
