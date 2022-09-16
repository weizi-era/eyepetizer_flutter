
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/utils/cache_manager.dart';

class AppInit {
  AppInit._();

  static Future<void> init() async {
    await CacheManager.preInit();
    Url.baseUrl = 'http://baobab.kaiyanapp.com/api/';
    // Future.delayed(Duration(milliseconds: 2000), () {
    //   FlutterSplashScreen.hide();
    // });
  }
}
