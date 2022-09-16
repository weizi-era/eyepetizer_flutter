import 'package:animations/animations.dart';
import 'package:eyepetizer_flutter/page/home/home_body_page.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/page/home/search_page.dart';
import 'package:eyepetizer_flutter/widget/app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(
        EyeString.home,
        showBack: false,
        actions: <Widget>[
          // 搜索图标
          _searchIcon(),
        ]
      ),
      body: HomeBodyPage(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _searchIcon() {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: OpenContainer(
        // 去掉默认阴影
        closedElevation: 0.0,
        closedBuilder: (context, action) {
          return Icon(Icons.search, color: Colors.black87,);
        },
        openBuilder: (context, action) {
          return SearchPage();
        },
      ),
    );
  }
}
