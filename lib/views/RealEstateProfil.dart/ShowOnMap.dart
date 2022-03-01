// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gamys/constants/constants.dart';
import 'package:get/get.dart';
import "package:latlong2/latlong.dart" as latlong;

class ShowOnMap extends StatelessWidget {
  final double lat;
  final double long;
  final String name;
  const ShowOnMap({Key key, this.lat, this.long, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // titleSpacing: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(CupertinoIcons.xmark, color: kPrimaryColor)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(name, style: const TextStyle(color: kPrimaryColor, fontSize: 18, fontFamily: robotoMedium)),
      ),
      body: FlutterMap(
        options: MapOptions(center: latlong.LatLng(lat, long), maxZoom: 18.0, minZoom: 3.0),
        layers: [
          TileLayerOptions(backgroundColor: Colors.white, urlTemplate: "$serverMapImage/tile/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: [
            Marker(
                width: 25.0,
                height: 25.0,
                point: latlong.LatLng(lat, long),
                builder: (ctx) => Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: const Icon(IconlyBold.home, size: 16, color: Colors.white))),
          ]),
        ],
      ),
    );
  }
}
