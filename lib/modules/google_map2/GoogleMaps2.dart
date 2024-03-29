import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import 'package:online_technician/shared/styles/colors.dart';

class GoogleMaps2 extends StatefulWidget {
 const GoogleMaps2({Key? key}) : super(key: key);

  @override
  State<GoogleMaps2> createState() => _GoogleMaps2State();
}

class _GoogleMaps2State extends State<GoogleMaps2> {
  /// محدش    يحرك حاجة من مكانها!!!!!!!!!!!!!
  bool c=true;
  bool v=false;
  final Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  LatLng from=LatLng(double.parse(CacheHelper.getData(key: 'latitude1')) , double.parse(CacheHelper.getData(key: 'longitude1')));
  LatLng to=LatLng(double.parse(CacheHelper.getData(key: 'latitude2')) , double.parse(CacheHelper.getData(key: 'longitude2')));
  static final CameraPosition _initialCameraPosition =  CameraPosition(
    target: LatLng((double.parse(CacheHelper.getData(key: 'latitude1'))+double.parse(CacheHelper.getData(key: 'latitude2')))/2 , (double.parse(CacheHelper.getData(key: 'longitude1'))+double.parse(CacheHelper.getData(key: 'longitude2')))/2),
    zoom: 10,
  );
  LatLng currentLocation = _initialCameraPosition.target;
  final HaversineDistance distance=HaversineDistance(4,5,6,7);
  bool ccc=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: header_color,
          elevation: 3.0,
          title:const Text(
              "المواقع علي الخريطة",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoNaskhArabic',
                  fontWeight: FontWeight.bold,
              ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:const Icon(Icons.arrow_back_sharp,color: Colors.white,),
          ),
      ),
      body:  Stack(
        alignment: Alignment.center,
        children:[ GoogleMap(
          zoomControlsEnabled: false,
          markers: _markers,
          initialCameraPosition:_initialCameraPosition,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            _setMarker(from);
            _setMarker(to);
          },
          onCameraMove: (CameraPosition newPos){
            setState(() {
              currentLocation=newPos.target;
            });
          },
        ),
          if(v)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: RichText(
                  text: TextSpan(
                    text: '${CacheHelper.getData(key: 'name2')}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    children: <TextSpan> [
                      const TextSpan(
                        text: ' يبعد عنك مسافة  ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '${CacheHelper.getData(key: 'dis')} كم',
                        style:const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],

                  ),
                ),

                /*Text(
                  '${CacheHelper.getData(key: 'name2')} is ${CacheHelper.getData(key: 'dis')} KM away from you',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),*/
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          setState(()  {
            v=true;
            ccc=true;
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(from.latitude, from.longitude),
                  zoom: 10,
                )
            ));
          });
          print('*******dddddddddddddddddddddddddddd*****ddddddddddddd******');
          double dis =distance.haversine(from.latitude, from.longitude, to.latitude, to.longitude, Unit.KM);
          print(dis);
        },
        child: Icon(Icons.directions,color:ccc?Colors.red:Colors.black,size: 35),
      ),
    );
  }
  void _setMarker(LatLng _location)  {
    print('******************************************mapsmapsmapsmapsmapsmapsmaps******************************');
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      // icon: _locationIcon,
      position: _location,
      infoWindow: InfoWindow(
        title:c ? CacheHelper.getData(key: 'name1'):CacheHelper.getData(key: 'name2'),
        //snippet: "${currentLocation.latitude}, ${currentLocation.longitude}"),
      ),
    );
    c=false;
    _markers.add(newMarker);
    setState(() {
    });
  }
}
/// تحذير تاني!!!!!!!!
/// محدش يحرك سطر كود من مكانه!!!!!!!!!!!!!!!!!!!!
class RADII {
  int km;
  int mile;
  int meter;
  int nmi;
  RADII(this.km, this.mile, this.meter, this.nmi);
}

enum Unit { KM, MILE, METER, NMI }

class HaversineDistance {
  double startCoordinateslatitude;
  double startCoordinateslongitude;
  double endCoordinateslatitude;
  double endCoordinateslongitude;
  HaversineDistance(
      this.startCoordinateslatitude,
      this.startCoordinateslongitude,
      this.endCoordinateslatitude,
      this.endCoordinateslongitude,
      );
  final RADII radii = RADII(6371, 3960, 6371000, 3440);
  double toRad(double num) {
    return num * pi / 180;
  }
  int getUnit(Unit unit) {
    switch (unit) {
      case (Unit.KM):
        return radii.km;
      case (Unit.MILE):
        return radii.mile;
      case (Unit.METER):
        return radii.meter;
      case (Unit.NMI):
        return radii.nmi;
      default:
        return radii.km;
    }
  }

  double haversine(
      double startCoordinateslatitude,
      double startCoordinateslongitude,
      double endCoordinateslatitude,
      double endCoordinateslongitude,
      Unit unit) {
    final R = getUnit(unit);
    final dLat = toRad(endCoordinateslatitude - startCoordinateslatitude);
    final dLon = toRad(endCoordinateslongitude - startCoordinateslongitude);
    final lat1 = toRad(startCoordinateslatitude);
    final lat2 = toRad(endCoordinateslatitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final d=R * c;
    CacheHelper.savaData(key: 'dis', value: d.toStringAsFixed(2));
    return d;
  }
}


