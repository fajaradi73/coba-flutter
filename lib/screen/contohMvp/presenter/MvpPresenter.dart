import 'dart:developer';

import 'package:coba_flutter/util/Constant.dart';
import 'package:coba_flutter/util/Utils.dart';

import '../model/MvpModel.dart';
import '../view/MvpView.dart';

class MvpPresenter {
  void onCalculateClicked(String weightString, String heightString) {}

  void onOptionChanged(int value,
      {required String weightString, required String heightString}) {}

  set view(MvpView value) {}

  void onAgeSubmitted(String age) {}

  void onHeightSubmitted(String height) {}

  void onWeightSubmitted(String weight) {}
}

class BasicMvpPresenter implements MvpPresenter {
  MvpModel model = MvpModel();
  MvpView view;

  BasicMvpPresenter(this.view) {
    loadUnit();
  }

  void loadUnit() async {
    model.value = await loadValue();
    view.updateUnit(model.value, model.heightMessage, model.weightMessage);
  }

  set mvpView(MvpView value) {
    view = value;
    view.updateUnit(model.value, model.heightMessage, model.weightMessage);
  }

  @override
  void onAgeSubmitted(String age) {
    // TODO: implement onAgeSubmitted
  }

  @override
  void onCalculateClicked(String weightString, String heightString) {
    var height = 0.0;
    var weight = 0.0;
    try {
      height = double.parse(heightString);
    } catch (e) {
      log(e.toString());
    }
    try {
      weight = double.parse(weightString);
    } catch (e) {
      log(e.toString());
    }
    model.height = height;
    model.weight = weight;
    model.bmi = calculator(height, weight, model.unitType);
    view.updateValue(model.bmiInString, model.bmiMessage);
  }

  @override
  void onHeightSubmitted(String height) {
    try {
      model.height = double.parse(height);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onOptionChanged(int value,
      {required String weightString, required String heightString}) {
    const weightScale = 2.2046226218;
    const heightScale = 2.54;
    double? height;
    double? weight;
    if (value != model.value) {
      model.value = value;
      saveValue(model.value);
      if (!isEmptyString(heightString)) {
        try {
          height = double.parse(heightString);
        } catch (e) {
          log(e.toString());
        }
      }
    }
    if (!isEmptyString(weightString)) {
      try {
        weight = double.parse(weightString);
      } catch (e) {
        log(e.toString());
      }
    }

    if(height != null && weight != null){
      if (model.unitType == UnitType.feetPound) {
        model.weight = weight * weightScale ;
        model.height = height / heightScale ;
      } else {
        model.weight = weight / weightScale ;
        model.height = height * heightScale ;
      }
    }

    view.updateUnit(model.value, model.heightMessage, model.weightMessage);
  }

  @override
  void onWeightSubmitted(String weight) {
    try {
      model.weight = double.parse(weight);
    } catch (e) {
      log(e.toString());
    }
  }
}
