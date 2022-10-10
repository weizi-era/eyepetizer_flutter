import 'dart:io';

import 'package:eyepetizer_flutter/app_init.dart';
import 'package:eyepetizer_flutter/page/video/video_detail_page.dart';
import 'package:eyepetizer_flutter/config/strings.dart';
import 'package:eyepetizer_flutter/tab_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:get/get.dart';

void main() => AppInit.run();

// void main() {
//
//   FlutterBugly.postCatchedException(() {
//     // 如果需要 ensureInitialized，请在这里运行。
//     WidgetsFlutterBinding.ensureInitialized();
//     runApp(const MyApp());
//     FlutterBugly.init(
//       androidAppId: "36af0fbfd6",
//     );
//   });
//
//   // Flutter沉浸式状态栏
//   if (Platform.isAndroid) {
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
//   }
//
//   // CacheManager.preInit();
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //异步UI更新
    return FutureBuilder(
      future: AppInit.init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        print(snapshot.connectionState);
        return GetMaterialAppWidget(child: TabNavigation());
      },
    );
  }
}

class GetMaterialAppWidget extends StatefulWidget {
  final Widget child;

  const GetMaterialAppWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<GetMaterialAppWidget> createState() => _GetMaterialAppWidgetState();
}

class _GetMaterialAppWidgetState extends State<GetMaterialAppWidget> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: EyeString.app_name,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => widget.child),
        GetPage(name: '/detail', page: () => VideoDetailPage()),
      ],
    );
  }
}

