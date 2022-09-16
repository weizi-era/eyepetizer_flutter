import 'package:flutter/material.dart';
import 'package:eyepetizer_flutter/model/discovery/topic_detail_model.dart';
import 'package:eyepetizer_flutter/state/base_state.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/viewmodel/discovery/topic_detail_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/app_bar.dart';
import 'package:eyepetizer_flutter/widget/topic_detail_item_widget.dart';

class TopicDetailPage extends StatefulWidget {
  final int detailId;

  const TopicDetailPage({Key? key, required this.detailId}) : super(key: key);

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState
    extends BaseState<TopicDetailViewModel, TopicDetailPage> {
  @override
  TopicDetailViewModel get viewModel => TopicDetailViewModel(widget.detailId);

  @override
  Widget getContentChild(TopicDetailViewModel model) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(model.topicDetailModel.brief!),
      // CustomScrollView:使用Sliver组件创建自定义滚动效果的滚动组件
      body: CustomScrollView(
        slivers: <Widget>[
          _headWidget(model.topicDetailModel),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return TopicDetailItemWidget(model: model.itemList[index]);
              },
              childCount: model.itemList.length,
            ),
          ),
        ],
      ),
    );
  }

  _headWidget(TopicDetailModel topicDetailModel) {
    // CustomScrollView只能包含sliver系列组件，如果包含普通的组件则需要使用SliverToBoxAdapter包裹
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // 图片
              cacheImage(
                topicDetailModel.headerImage!,
                width: MediaQuery.of(context).size.width,
                height: 250,
              ),
              // 图片的文字介绍
              Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                child: Text(
                  topicDetailModel.text!,
                  style: TextStyle(fontSize: 12, color: Color(0xff9a9a9a)),
                ),
              ),
              Container(
                height: 5,
                color: Colors.black12,
              ),
            ],
          ),
          // 图片的title
          Positioned(
            left: 20,
            right: 20,
            top: 230,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                topicDetailModel.brief!,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                // 背景色
                color: Colors.white,
                // 边框设置
                border: Border.all(color: Color(0xFFF5F5F5)),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

}