// ignore_for_file: deprecated_member_use, file_names, depend_on_referenced_packages, always_declare_return_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/ProfilPageController.dart';
import 'package:gamys/models/GetLocation.dart';
import 'package:gamys/views/RealEstateProfil.dart/RealEstateProfil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import "package:latlong2/latlong.dart" as latlong;
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  final Map<String, dynamic> parametrsMine;

  const MapPage({Key key, this.parametrsMine}) : super(key: key);
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ProfilePageController profilePageController = Get.put(ProfilePageController());

  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());
  double currentUserLat = 37.922252;
  double currentUserLong = 58.376016;
  double currentZoom = 13.0;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  MapController mapController;
  double maxZoom = 18.0;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    mapController = MapController();
  }

  _getCurrentLocation() {
    geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        currentUserLat = position.latitude;
        currentUserLong = position.longitude;
      });
    }).catchError((e) {});
  }

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      showSnackBar("location", 'turnOnLocation', kPrimaryColor);
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.denied) {
      showSnackBar("location", 'turnOnLocation', kPrimaryColor);
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _zoomMinus() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      showSnackBar("location", 'turnOnLocation', kPrimaryColor);
      return;
    } else {
      currentZoom = currentZoom - 1;
      mapController.move(latlong.LatLng(currentUserLat, currentUserLong), currentZoom);
    }
  }

  Future<void> _zoomPlus() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      showSnackBar("location", 'turnOnLocation', kPrimaryColor);
      return;
    } else {
      if (maxZoom > currentZoom) {
        currentZoom = currentZoom + 1;
      } else {
        showSnackBar("maxZoom", 'maxZoom1.', kPrimaryColor);
      }

      mapController.move(latlong.LatLng(currentUserLat, currentUserLong), currentZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(
            name: "showMapFilter".tr,
            backArrow: true,
          ),
          body: FutureBuilder<List<GetMapArray>>(
              future: GetMapArray().getRealEstatesPostion(parametrs: widget.parametrsMine),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FlutterMap(
                    mapController: mapController,
                    nonRotatedChildren: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    _zoomPlus();
                                  },
                                  color: Colors.white,
                                  disabledColor: Colors.white,
                                  padding: const EdgeInsets.all(5),
                                  minWidth: 0,
                                  shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                                  child: const Icon(Icons.add, color: Colors.blue, size: 30),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    _zoomMinus();
                                  },
                                  color: Colors.white,
                                  disabledColor: Colors.white,
                                  padding: const EdgeInsets.all(5),
                                  minWidth: 0,
                                  shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                                  child: const Icon(CupertinoIcons.minus, color: Colors.blue, size: 30),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    _checkPermission();
                                  },
                                  color: Colors.white,
                                  disabledColor: Colors.white,
                                  padding: const EdgeInsets.all(5),
                                  minWidth: 0,
                                  shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                                  child: const Icon(IconlyLight.location, color: Colors.blue, size: 30),
                                ),
                              ],
                            ),
                          )),
                    ],
                    options: MapOptions(
                      onTap: ((tapPosition, point) {}),
                      // min
                      pinchZoomThreshold: 0.1,
                      center: latlong.LatLng(currentUserLat, currentUserLong),
                      maxZoom: maxZoom,
                    ),
                    layers: [
                      TileLayerOptions(backgroundColor: Colors.white, urlTemplate: "$serverMapImage/tile/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(
                          markers: List.generate(snapshot.data.length, (index) {
                        return Marker(
                            width: 25.0,
                            height: 25.0,
                            point: latlong.LatLng(snapshot.data[index].lat, snapshot.data[index].lng),
                            builder: (ctx) => GestureDetector(
                                onTap: () {
                                  Get.to(() => RealEstateProfil(
                                        id: snapshot.data[index].id,
                                        name: snapshot.data[index].name,
                                        price: snapshot.data[index].price.toString(),
                                      ));
                                  if (historyView.isEmpty) {
                                    historyView.add(snapshot.data[index].id);
                                  } else {
                                    bool value = false;
                                    for (final element in historyView) {
                                      if (element == snapshot.data[index].id) {
                                        value = true;
                                      }
                                    }
                                    if (value == false) historyView.add(snapshot.data[index].id);
                                  }
                                },
                                child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: const Icon(Icons.circle, color: Colors.white))));
                      })),
                      MarkerLayerOptions(markers: [
                        Marker(
                            width: 30.0,
                            height: 30.0,
                            point: latlong.LatLng(currentUserLat, currentUserLong),
                            builder: (ctx) => Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: Icon(IconlyBold.profile, size: 24, color: Colors.white))),
                      ]),
                    ],
                  );
                }
                return spinKit();
              })),
    );
  }
}
