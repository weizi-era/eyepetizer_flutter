import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///本地缓存管理类
class SPUtils {
  SharedPreferences? _preferences;

  SPUtils._();

  SPUtils._pre(SharedPreferences preferences) {
    _preferences = preferences;
  }

  static SPUtils? _instance;

  static SPUtils getInstance() {
    _instance ??= SPUtils._();
    return _instance!;
  }

  //预初始化，防止get时，SharedPreferences还未初始化完毕
  static Future<SPUtils> preInit() async {
    if (_instance == null) {
      var preferences = await SharedPreferences.getInstance();
      _instance = SPUtils._pre(preferences);
    }
    return _instance!;
  }

  set(String key, Object value) {
    if (value is int) {
      _preferences!.setInt(key, value);
    } else if (value is String) {
      _preferences!.setString(key, value);
    } else if (value is double) {
      _preferences!.setDouble(key, value);
    } else if (value is bool) {
      _preferences!.setBool(key, value);
    } else if (value is List<String>) {
      _preferences!.setStringList(key, value);
    } else {
      throw Exception("only Support int、String、double、bool、List<String>");
    }
  }

  T? get<T>(String key) {
    debugPrint("_preferences == $_preferences");
    return _preferences!.get(key) as T;
  }
}
