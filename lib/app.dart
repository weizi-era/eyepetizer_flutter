
import 'package:eyepetizer_flutter/main.dart';
import 'package:eyepetizer_flutter/utils/bugly.dart';
import 'package:eyepetizer_flutter/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

class App {

  static void run() {

    WidgetsFlutterBinding.ensureInitialized();

    runApp(const MyApp());

    Bugly.init();

  }
}