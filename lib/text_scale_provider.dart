import 'package:flutter/material.dart';

class TextScaleProvider extends ChangeNotifier {
  double _scale = 1.0;
  double get scale => _scale;

  void setScale(double value) {
    _scale = value;
    notifyListeners();
  }
}
