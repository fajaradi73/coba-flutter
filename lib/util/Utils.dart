import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:coba_flutter/util/Constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart';

String determineBMIMessage(double value) {
  if (value < 15.0) {
    return 'Very severely underweight';
  } else if (value >= 15.0 && value < 16.0) {
    return 'Severely underweight';
  } else if (value >= 16.0 && value < 18.5) {
    return 'Underweight';
  } else if (value >= 18.5 && value < 25.0) {
    return 'Normal (healthy weight)';
  } else if (value >= 25.0 && value < 30.0) {
    return 'Overweight';
  } else if (value >= 30.0 && value < 35.0) {
    return 'Moderately obese';
  } else if (value >= 35.0 && value < 40.0) {
    return 'Severely obese';
  } else if (value >= 40) {
    return 'Very serverely obese';
  } else {
    return '';
  }
}

double calculator(double height, double weight, UnitType uniType) {
  if (height <= 0.0) return 0.0;
  double bmiValue = uniType == UnitType.kilogramMeter
      ? (weight / pow(height / 100, 2))
      : (weight / pow(height, 2) * 703);
  return bmiValue;
}

bool isEmptyString(String string) {
  return string.isEmpty;
}

Future<int> loadValue() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int data = preferences.getInt('data') ?? 0;
  return data;
}

void saveValue(int value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('data', value);
}

getAddressFromLatLng(context, double lat, double lng) async {
  String host = 'https://maps.google.com/maps/api/geocode/json';
  final url =
      '$host?key=AIzaSyAd0Senk1tiMssHceMI-wqvRIo83exeKYU&language=en&latlng=$lat,$lng';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    Map data = jsonDecode(response.body);
    String formattedAddress = data["results"][0]["formatted_address"];
    if (kDebugMode) {
      print("response ==== $formattedAddress");
    }
    return formattedAddress;
  } else {
    return null;
  }
}

dynamic jsonDecode(String source,
        {Object? Function(Object? key, Object? value)? reviver}) =>
    json.decode(source, reviver: reviver);

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

double getBearing(LatLng begin, LatLng end) {
  double lat = (begin.latitude - end.latitude).abs();
  double lng = (begin.longitude - end.longitude).abs();

  if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
    return degrees(atan(lng / lat));
  } else if (begin.latitude >= end.latitude &&
      begin.longitude < end.longitude) {
    return (90 - degrees(atan(lng / lat))) + 90;
  } else if (begin.latitude >= end.latitude &&
      begin.longitude >= end.longitude) {
    return degrees(atan(lng / lat)) + 180;
  } else if (begin.latitude < end.latitude &&
      begin.longitude >= end.longitude) {
    return (90 - degrees(atan(lng / lat))) + 270;
  }
  return -1;
}
