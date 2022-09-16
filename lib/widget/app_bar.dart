
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

appBar(String title, {bool showBack = true, List<Widget>? actions, PreferredSizeWidget? bottom}) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    leading: showBack? BackButton(color: Colors.black,) : null,
    actions: actions,
    title: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottom: bottom,
  );
}