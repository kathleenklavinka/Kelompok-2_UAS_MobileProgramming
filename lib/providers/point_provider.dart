import 'package:flutter/material.dart';

class PointProvider extends ChangeNotifier {
  int _points = 5000;
  int _pointsaccumulated = 5000;

  int get points => _points;
  int get pointsAccumulated => _pointsaccumulated;

  void addPoints(int amount) {
    _points += amount;
    _pointsaccumulated += amount;
    notifyListeners();
  }

  bool redeemPoints(int amount) {
    if (_points >= amount) {
      _points -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }
}