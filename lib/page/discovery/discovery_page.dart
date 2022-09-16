
import 'package:eyepetizer_flutter/page/discovery/category_page.dart';
import 'package:eyepetizer_flutter/page/discovery/follow_page.dart';
import 'package:eyepetizer_flutter/page/discovery/news_page.dart';
import 'package:eyepetizer_flutter/page/discovery/recommend_page.dart';
import 'package:eyepetizer_flutter/page/discovery/topic_page.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/widget/app_bar.dart';
import 'package:eyepetizer_flutter/widget/tab_bar.dart';
import 'package:flutter/material.dart';

const TAB_LABEL = ["关注", "分类", "专题", "资讯", "推荐"];

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: TAB_LABEL.length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(
        EyeString.discovery,
        showBack: false,
        bottom: tabBar(
          controller: _tabController,
          tabs: TAB_LABEL.map((label) {
            return Tab(text: label,);
          }).toList(),
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FollowPage(),
          CategoryPage(),
          TopicPage(),
          NewsPage(),
          RecommendPage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
