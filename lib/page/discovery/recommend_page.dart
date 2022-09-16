import 'dart:math';

import 'package:eyepetizer_flutter/widget/recommend_loading.dart';
import 'package:flutter/material.dart';
import 'package:eyepetizer_flutter/model/discovery/recommend_model.dart';
import 'package:eyepetizer_flutter/widget/recommend_item_widget.dart';
import 'package:loading_more_list/loading_more_list.dart';

class RecommendPage extends StatefulWidget {

  const RecommendPage({Key? key}) : super(key: key);

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin {
  final RecommendLoading _recommendLoading = RecommendLoading();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // RefreshIndicator：下拉刷新
      body: RefreshIndicator(
        onRefresh: _refresh,
        // LayoutBuilder：获取父组件的约束尺寸
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // 交叉轴方向的个数最少两个
            final int crossAxisCount = max(
              // 父容器给的宽度 ~/ 屏幕宽度的一半
                constraints.maxWidth ~/
                    (MediaQuery.of(context).size.width / 2.0),
                2);
            // 加载更多
            return LoadingMoreList<RecommendItem>(
              ListConfig<RecommendItem>(
                // 扩展 WaterfallFlow(瀑布流) 等列表--默认flutter没有实现瀑布流
                extendedListDelegate:
                SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, item, index) =>
                    RecommendItemWidget(item: item),
                sourceList: _recommendLoading,
                padding: const EdgeInsets.all(5.0),
                lastChildLayoutType: LastChildLayoutType.foot,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _recommendLoading.dispose();
  }

  Future<bool> _refresh() async {
    return _recommendLoading.refresh().whenComplete(() => null);
  }

  @override
  bool get wantKeepAlive => true;
}