import 'package:flutter/material.dart';

class CentralProvider extends ChangeNotifier {
  bool fabVisibility = false;
  double loadingProgressIndicator = 0.0;
  bool progressIndicatorVisibility = false;

  void notify() {
    return notifyListeners();
  }
}
