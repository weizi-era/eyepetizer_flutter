
import 'package:flutter_bugly/flutter_bugly.dart';

class Bugly {

  Bugly._internal();

  static const String BUGLY_APP_ID_ANDROID = "36af0fbfd6";
  static const String BUGLY_APP_ID_IOS = "36af0fbfd6";// iOS暂未申请id

//============================统计==================================//

  ///初始化Bugly
  static void init() {
    FlutterBugly.init(
        androidAppId: BUGLY_APP_ID_ANDROID,
        iOSAppId: BUGLY_APP_ID_IOS)
        .then((result) {
      print("Bugly初始化结果: ${result.message}");
      print("Bugly初始化结果: ${result.isSuccess}" );
    });
  }

  //============================更新==================================//

  ///检查更新
  static Future<UpgradeInfo?> checkUpgrade() {
    return FlutterBugly.checkUpgrade();
  }

}