import 'package:eyepetizer_flutter/page/discovery/discovery_page.dart';
import 'package:eyepetizer_flutter/page/home/home_page.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/page/hot/hot_page.dart';
import 'package:eyepetizer_flutter/page/mine/mine_page.dart';
import 'package:eyepetizer_flutter/utils/toast_util.dart';
import 'package:eyepetizer_flutter/viewmodel/tab_navigation_viewmodel.dart';
import 'package:eyepetizer_flutter/widget/provider_widget.dart';
import 'package:flutter/material.dart';

class TabNavigation extends StatefulWidget {
  const TabNavigation({Key? key}) : super(key: key);

  @override
  State<TabNavigation> createState() => _TabNavigationState();
}

class _TabNavigationState extends State<TabNavigation> {
  DateTime? lastTime;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // 防止用户误触
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            DiscoveryPage(),
            HotPage(),
            MinePage(),
          ],
        ),
        bottomNavigationBar: ProviderWidget<TabNavigationViewModel>(
          model: TabNavigationViewModel(),
          builder: (context, model, child) {
              return BottomNavigationBar(
                currentIndex: model.currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xff000000),
                unselectedItemColor: Color(0xff8a8a8a),
                items: _item(),
                onTap: (index) {
                  if (model.currentIndex != index) {
                    _pageController.jumpToPage(index);
                    model.changeBottomTabIndex(index);
                  }
                },
              );
          },
        )

       ),
    );
  }

  List<BottomNavigationBarItem> _item() {
    return [
      _bottomItem(EyeString.home, "images/ic_home_normal.png",
          "images/ic_home_selected.png"),
      _bottomItem(EyeString.discovery, "images/ic_discovery_normal.png",
          "images/ic_discovery_selected.png"),
      _bottomItem(EyeString.hot, "images/ic_hot_normal.png",
          "images/ic_hot_selected.png"),
      _bottomItem(EyeString.mine, "images/ic_mine_normal.png",
          "images/ic_mine_selected.png"),
    ];
  }

  _bottomItem(String title, String normalIcon, String selectorIcon) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        normalIcon,
        width: 24,
        height: 24,
      ),
      activeIcon: Image.asset(
        selectorIcon,
        width: 24,
        height: 24,
      ),
      label: title,
    );
  }

  Future<bool> _onWillPop() async {
    if (lastTime == null ||
        DateTime.now().difference(lastTime!) > Duration(seconds: 2)) {
      lastTime = DateTime.now();
      ToastUtil.showTip(EyeString.exit);
      return false;
    } else {
      // 自动出栈
      return true;
    }
  }
}
