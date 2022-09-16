import 'package:flutter/material.dart';

TabBar tabBar({
  required List<Widget> tabs,
  TabController? controller,
  ValueChanged<int>? onTap,
  double? selectedFontSize = 16,
  double? unselectedFontSize = 14,
  Color? labelColor = Colors.black,
  Color? unselectedLabelColor = const Color(0xff8a8a8a),
  Color? indicatorColor = Colors.black,
  TabBarIndicatorSize? indicatorSize = TabBarIndicatorSize.label,
}) {
  return TabBar(
    tabs: tabs,
    controller: controller,
    onTap: onTap,
    labelColor: labelColor,
    unselectedLabelColor: unselectedLabelColor,
    labelStyle: TextStyle(fontSize: selectedFontSize, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: unselectedFontSize),
    indicatorColor: indicatorColor,
    indicatorSize: indicatorSize,
  );
}
