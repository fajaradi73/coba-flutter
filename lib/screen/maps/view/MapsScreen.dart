import 'dart:async';

import 'package:coba_flutter/screen/maps/presenter/MapsPresenter.dart';
import 'package:coba_flutter/screen/maps/view/MapsView.dart';
import 'package:coba_flutter/util/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen>
    with TickerProviderStateMixin, MapsView {
  final List<Marker> _markers = <Marker>[];

  Position? currentPosition;

  final _mapMarkerSC = StreamController<List<Marker>>();

  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;

  late MapsPresenter presenter;
  GoogleMapController? mapController;
  String googleApikey = "AIzaSyAd0Senk1tiMssHceMI-wqvRIo83exeKYU";

  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyAd0Senk1tiMssHceMI-wqvRIo83exeKYU");
  final List<Polyline> polyline = [];
  List<LatLng> routeCords = [];

  PlaceDetails? detailsArrive;

  @override
  void initState() {
    super.initState();
    presenter = BasicMapsPresenter(this);
    asyncMethod();
  }

  void asyncMethod() async {
    currentPosition = await presenter.getGeoLocationPosition();
    if (currentPosition != null) getAddressFromLatLong(currentPosition!);
    setUpCurrentLocation();
    setState(() {});
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
      var address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      setState(() {});
    }
  }

  Future<void> displayPrediction(Prediction? p) async {
    var placeId = p?.placeId;

    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: "AIzaSyAd0Senk1tiMssHceMI-wqvRIo83exeKYU",
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    if (placeId != null && placeId.isNotEmpty) {
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(placeId);

      double lat = detail.result.geometry?.location.lat ?? 0;
      double lng = detail.result.geometry?.location.lng ?? 0;
      setUpMarker(lat, lng, detail.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentLocationCamera = CameraPosition(
      target: LatLng(
          currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0),
      zoom: 14.4746,
    );

    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentLocationCamera,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: Set<Marker>.of(snapshot.data ?? []),
            polylines: Set.from(polyline),
            padding: const EdgeInsets.all(8),
          );
        });

    var buttonHeader = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20, top: 40),
            height: 45,
            width: 45,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                child: SvgPicture.asset("assets/icons/ic_back.svg"),
              ),
            )),
        Container(
            margin: const EdgeInsets.only(left: 20, top: 40, right: 20),
            height: 45,
            width: 45,
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: InkWell(
              onTap: () {
                setUpPlaceAutoComplete();
              },
              child: Container(
                  margin: const EdgeInsets.all(15),
                  child: const Image(
                    image: AssetImage("assets/icons/ic_search.png"),
                  )),
            ))
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          (currentPosition != null)
              ? googleMap
              : Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Colors.purpleAccent,
                  )),
          buttonHeader,
        ],
      ),
    );
  }

  setUpPlaceAutoComplete() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleApikey,
        mode: Mode.overlay,
        language: "id",
        types: ["address"],
        region: "id",
        strictbounds: false,
        components: [Component(Component.country, "id")],
        onError: (err) {
          if (kDebugMode) {
            print(err);
          }
        });
    if (p != null) displayPrediction(p);
  }

  setUpMarker(double lat, double lng, PlaceDetails placeDetail) async {
    detailsArrive = placeDetail;
    if (_markers.length > 1) {
      _markers.removeAt(_markers.length - 1);
    }
    var currentLocationCamera = LatLng(lat, lng);
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocationCamera, zoom: 15)));
    final pickupMarker = Marker(
        markerId: MarkerId("${currentLocationCamera.latitude}"),
        position: LatLng(
            currentLocationCamera.latitude, currentLocationCamera.longitude),
        icon: BitmapDescriptor.fromBytes(
            await getBytesFromAsset('assets/icons/ic_pin.png', 70)),
        infoWindow: InfoWindow(title: placeDetail.name));

    //Adding a delay and then showing the marker on screen
    await Future.delayed(const Duration(milliseconds: 500));

    _markers.add(pickupMarker);
    _mapMarkerSink.add(_markers);
    computePath();
    setState(() {});
  }

  setUpCurrentLocation() async {
    var currentLocationCamera =
        LatLng(currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0);

    final pickupMarker = Marker(
      markerId: MarkerId("${currentLocationCamera.latitude}"),
      position: LatLng(
          currentLocationCamera.latitude, currentLocationCamera.longitude),
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/icons/ic_car.png', 70)),
    );

    //Adding a delay and then showing the marker on screen
    await Future.delayed(const Duration(milliseconds: 500));

    _markers.add(pickupMarker);
    _mapMarkerSink.add(_markers);
    setState(() {});
  }

  computePath() async {
    LatLng? origin =
        LatLng(currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0);
    LatLng? end = LatLng(detailsArrive?.geometry?.location.lat ?? 0,
        detailsArrive?.geometry?.location.lng ?? 0);
    routeCords.addAll(await googleMapPolyline.getCoordinatesWithLocation(
            origin: origin, destination: end, mode: RouteMode.driving) ??
        []);
    polyline.add(Polyline(
        polylineId: const PolylineId('iter'),
        visible: true,
        points: routeCords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap));
    setState(() {});
  }
}
