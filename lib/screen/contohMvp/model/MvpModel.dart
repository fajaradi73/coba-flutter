
import 'package:coba_flutter/util/Constant.dart';
import 'package:coba_flutter/util/Utils.dart';

class MvpModel {
  double bmi = 0.0;
  UnitType unitType = UnitType.feetPound;

  double height = 0.0;
  double weight = 0.0;

  int get value => unitType == UnitType.feetPound ? 0 : 1;

  set value(int value) {
    unitType = value == 0 ? UnitType.feetPound : UnitType.kilogramMeter;
  }

  String get heightMessage =>
      unitType == UnitType.feetPound ? "Height in feet" : "Height in meters";

  String get weightMessage => unitType == UnitType.feetPound
      ? "Weight in pounds"
      : "Weight in kilograms";

  String get bmiMessage => determineBMIMessage(bmi);

  String get bmiInString => bmi.toStringAsFixed(2);

  String get heightInString => height.toString();

  String get weightInString => weight.toString();

  MvpModel();

}
