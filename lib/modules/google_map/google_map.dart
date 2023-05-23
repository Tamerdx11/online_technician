import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/styles/colors.dart';
import '../../shared/network/local/cache_helper.dart';
import '../LocationService/LocationService.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCameraPosition =  CameraPosition(
    target: LatLng(30.474255520959225, 31.19935470680645),
    zoom: 19.4746,
  );



  LatLng currentLocation = _initialCameraPosition.target;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(' الموقع علي الخريطة', style: TextStyle(color: Colors.white),),
        backgroundColor: header_color,
        centerTitle: true,
      ),
      body:  GoogleMap(
        markers: _markers,
          polylines: _polylines,
          initialCameraPosition:_initialCameraPosition,
        onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
        },
        onCameraMove: (CameraPosition newPos){
            setState(() {
              currentLocation=newPos.target;
            });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: SizedBox(
          width: 130.0,
          height: 40.0,
          child: FloatingActionButton(
            onPressed: (){
              _getMyLocation();
              },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 3.0,
            child:const Text('تحديد موقعي'),
          ),
        ),
      ),
    );
  }


  Future<void> _getMyLocation() async {
    ///_my location
    LocationData _myLocation = await LocationService().getLocation();
    _animateCamera(LatLng(_myLocation.latitude!, _myLocation.longitude!));
    LatLng current=await LatLng(_myLocation.latitude!, _myLocation.longitude!);
    _setMarker(current);
    latitude  = _myLocation.latitude;
    longitude = _myLocation.longitude;
    test(latitude!,longitude!);
    CacheHelper.savaData(key: 'latitude1', value: _myLocation.latitude);
    CacheHelper.savaData(key: 'longitude1', value: _myLocation.longitude);
    print('============================================///////////////');
    print(latitude);
    print(longitude);
  }

  Future<void> _animateCamera(LatLng _location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(_location.latitude, _location.longitude),
      zoom: 14.4746,
    );
    print('**************************************');
    print(
        "animating camera to (lat: ${_location.latitude}, long: ${_location.longitude}");
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }


  void _setMarker(LatLng _location)  {
    print('******************************************//////////////////////******************************');
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      // icon: _locationIcon,
      position: _location,

      infoWindow: InfoWindow(
          title: CacheHelper.getData(key: 'name1',),
          //snippet: "${currentLocation.latitude}, ${currentLocation.longitude}"),
      )
    );
    _markers.add(newMarker);
    setState(() {
    });
  }

  Future<void> test(double lat,double long) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(lat, long,localeIdentifier: 'ar_EG');
    Placemark place1 = placemarks[0];
    Placemark place2 = placemarks[1];
    String _currentAddress = "${place1.subAdministrativeArea}";
    location=_currentAddress;
    ///print("****************////////////*****************************");
    ///print(place1.name);
    ///print(place2.name);
    ///print(place2.subAdministrativeArea);
    ///print(place1.postalCode);
  }

}

/// google map ==> الخريطة
/// marker ==> العلامة
/// polygon ==> الخط الازرق اقصر مسافة بين علامتين وهيبقي متفاعل  ==> order