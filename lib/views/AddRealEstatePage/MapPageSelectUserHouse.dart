// ignore_for_file: deprecated_member_use, file_names, depend_on_referenced_packages, annotate_overrides

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import "package:latlong2/latlong.dart" as latlong;
import 'package:permission_handler/permission_handler.dart';

class MapPageSelectUserHouse extends StatefulWidget {
  State<MapPageSelectUserHouse> createState() => _MapPageSelectUserHouseState();
}

class _MapPageSelectUserHouseState extends State<MapPageSelectUserHouse> {
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

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

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    final status = await Permission.locationWhenInUse.request();

    if (!isGpsOn) {
      showSnackBar("location", 'turnOnLocation', kPrimaryColor);
      return;
    }

    if (status == PermissionStatus.granted) {
      geolocator.getCurrentPosition().then((Position position) {
        setState(() {
          currentUserLat = position.latitude;
          currentUserLong = position.longitude;
        });
      }).catchError((e) {});
    } else if (status == PermissionStatus.denied) {
      showSnackBar("permissionDenied", 'permissionDeniedSubtitleLocation', kPrimaryColor);
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _zoomMinus() async {
    _checkPermission();
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
    _checkPermission();
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      showSnackBar("location", 'turnOnLocation', kPrimaryColor);
      return;
    } else {
      if (maxZoom > currentZoom) {
        currentZoom = currentZoom + 1;
      } else {
        showSnackBar("Max Zoom", 'Zoom bolonok.', kPrimaryColor);
      }

      mapController.move(latlong.LatLng(currentUserLat, currentUserLong), currentZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FlutterMap(
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
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: Get.size.width,
              child: Obx(() {
                return RaisedButton(
                    onPressed: () {
                      bottomNavBarController.currentUserLat2.value = currentUserLat;
                      bottomNavBarController.currentUserLong2.value = currentUserLong;
                      addRealEstateController.currentZoom.value = 15.0;
                      Get.back();
                    },
                    disabledColor: Colors.green.shade500,
                    elevation: addRealEstateController.currentZoom.value == 15.0 ? 2 : 3,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                    color: Colors.green.shade500,
                    child: Text("agree".tr, style: const TextStyle(fontFamily: robotoBold, color: Colors.white, fontSize: 18)));
              }),
            ),
          )
        ],
        options: MapOptions(
          onTap: ((tapPosition, point) async {
            final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
            final isGpsOn = serviceStatus == ServiceStatus.enabled;

            if (!isGpsOn) {
              showSnackBar("location", 'turnOnLocation', kPrimaryColor);
            } else {
              setState(() {
                currentUserLong = point.longitude;
                currentUserLat = point.latitude;
              });
            }
          }),
          pinchZoomThreshold: 0.1,
          center: latlong.LatLng(currentUserLat, currentUserLong),
          maxZoom: maxZoom,
        ),
        layers: [
          TileLayerOptions(backgroundColor: Colors.white, urlTemplate: "$serverMapImage/tile/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: [
            Marker(
                width: 20.0,
                height: 20.0,
                point: latlong.LatLng(currentUserLat, currentUserLong),
                builder: (ctx) => Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: const Icon(IconlyBold.profile, size: 16, color: Colors.white))),
          ]),
        ],
      )),
    );
  }
}
