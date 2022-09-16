import 'package:eyepetizer_flutter/viewmodel/base_change_notifier.dart';

class RecommendPhotoViewModel extends BaseChangeNotifier {
  int currentIndex = 1;

  changeIndex(int index) {
    currentIndex = index + 1;
    notifyListeners();
  }
}