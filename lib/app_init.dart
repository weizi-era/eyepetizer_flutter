import 'dart:async';
import 'dart:io';

import 'package:eyepetizer_flutter/app.dart';
import 'package:eyepetizer_flutter/http/url.dart';
import 'package:eyepetizer_flutter/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

class AppInit {
  AppInit._();

  static Future<void> init() async {
    await SPUtils.preInit();
    Url.baseUrl = 'http://baobab.kaiyanapp.com/api/';
    // Future.delayed(Duration(milliseconds: 2000), () {
    //   FlutterSplashScreen.hide();
    // });
  }

  static void run() {

    /// Flutter沉浸式状态栏
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
    FlutterBugly.postCatchedException(() {
      /// bugly 数据上报
      App.run();
    });
  }

  /// 异常捕获处理
  static void catchException<T>(T Function() callback) {
    /// 捕获异常的回调
    FlutterError.onError = (FlutterErrorDetails details) {
      reportErrorAndLog(details);
    };
    runZoned<Future<void>>(
      () async {
        callback();
      },
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          /// 收集日志
          collectLog(parent, zone, line);
        },
      ),

      /// 未捕获的异常的回调
      onError: (Object obj, StackTrace stack) {
        var details = makeDetails(obj, stack);
        reportErrorAndLog(details);
      },
    );

    ///  重写异常页面
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      print(flutterErrorDetails.toString());
      return Scaffold(
          body: Center(
        child: Text("出了点问题，我们马上修复~"),
      ));
    };
  }

  /// 日志拦截, 收集日志
  static void collectLog(ZoneDelegate parent, Zone zone, String line) {
    parent.print(zone, "日志拦截: $line");
  }

  /// 上报错误和日志逻辑
  static void reportErrorAndLog(FlutterErrorDetails details) {
    print('上报错误和日志逻辑: $details');
    print(details);
  }

  ///  构建错误信息
  static FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
    return FlutterErrorDetails(stack: stack, exception: obj);
  }
}
