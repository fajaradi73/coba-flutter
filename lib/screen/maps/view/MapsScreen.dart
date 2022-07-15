import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  String location = 'Null, Press Button';
  String address = 'search';
  Position? position;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  void asyncMethod() async {
    position = await _getGeoLocationPosition();
    location = 'Lat: ${position?.latitude} , Long: ${position?.longitude}';
    if (position != null) getAddressFromLatLong(position!);
    setState(() {});
  }

  Future<Position> _getGeoLocationPosition() async {
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

  void getAddressFromLatLong(Position position) async {
    double? latitude = position.latitude;
    double? longitude = position.longitude;
    if (latitude != 0 && longitude != 0) {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (kDebugMode) {
        print(placeMarks);
      }
      Placemark place = placeMarks[0];
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
        zoom: 15.0,
      ),
      myLocationEnabled: true,
      mapType: MapType.normal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: (position != null)
          ? googleMap
          : Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.purpleAccent,
              )),
    );
  }
}
