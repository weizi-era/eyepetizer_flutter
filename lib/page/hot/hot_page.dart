import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/http/http_manager.dart';
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/model/tab_info_model.dart';
import 'package:eyepetizer_flutter/page/hot/hot_list_page.dart';
import 'package:eyepetizer_flutter/utils/toast_util.dart';
import 'package:eyepetizer_flutter/widget/app_bar.dart';
import 'package:eyepetizer_flutter/widget/tab_bar.dart';
import 'package:flutter/material.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  List<TabInfoItem> _tabList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
    _loadData();
  }

  @override
  void setState(VoidCallback fn) {
    // 判断是否渲染完成，防止数据还没有获取到，此时setState触发的控件渲染就会报错
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        EyeString.popularity_list,
        showBack: false,
        bottom: tabBar(
            tabs: _tabList.map((label) {
              return Tab(
                text: label.name,
              );
            }).toList(),
            controller: _tabController,),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabList.map((label) {
          return HotListPage(apiUrl: label.apiUrl!);
        }).toList(),
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

  void _loadData() {
    HttpManager.getData(
      Url.rankUrl,
      success: (json) {
        TabInfoModel tabInfoModel = TabInfoModel.fromJson(json);
        setState(() {
          _tabList = tabInfoModel.tabInfo!.tabList!;
          _tabController = TabController(length: _tabList.length, vsync: this);
        });
      },
      fail: (e) {
        ToastUtil.showError(e.toString());
      },
      complete: () {

      },
    );
  }
}
