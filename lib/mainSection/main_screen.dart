import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GoogleMapController mapController;
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};

  String presentAddress;

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _getUserLocation() async {
  
    Position position = await Geolocator().getCurrentPosition();

    setState(() {
      print(position.latitude);
      print(position.longitude);
      _initialPosition = LatLng(position.latitude, position.longitude);
    });

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    _addMarker(_initialPosition, placemark[0].name);
  }

  void _addMarker(LatLng location, String address) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(title: address, snippet: "You Live Here"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Find My Lost Phone"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Container(
                      height: 300,
                      child: Card(
                        child: _initialPosition == null
                            ? Container(
                                alignment: Alignment.center,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: _initialPosition, zoom: 15.0),
                                onMapCreated: onCreated,
                                myLocationEnabled: true,
                                mapType: MapType.terrain,
                                compassEnabled: false,
                                markers: _markers,
                                onCameraMove: _onCameraMove,

                                //polylines: _polyLines,
                              ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
