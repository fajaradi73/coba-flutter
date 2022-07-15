import 'package:coba_flutter/screen/home/model/HomeModel.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../view/HomeView.dart';

class HomePresenter {
  getAddressFromLatLong(Position position){}
  getGeoLocationPosition() {}
  getMenu(){}
}

class BasicHomePresenter implements HomePresenter{
  HomeView view;
  HomeModel model = HomeModel();

  BasicHomePresenter(this.view);

  @override
  getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  getAddressFromLatLong(Position position) async {
    double? latitude = position.latitude;
    double? longitude = position.longitude;
    if (latitude != 0 && longitude != 0) {
      List<Placemark> placeMarks =
      await placemarkFromCoordinates(latitude, longitude);
      if (kDebugMode) {
        print(placeMarks);
      }
      Placemark place = placeMarks[0];
      return '${place.locality}';
      // return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    }
  }

  @override
  getMenu() {
    return model.getMenu;
  }
}
