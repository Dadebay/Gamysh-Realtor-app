// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:http/http.dart' as http;

import 'UserModels/AuthModel.dart';

class GetLocationModel extends ChangeNotifier {
  GetLocationModel({this.id, this.locationName});

  factory GetLocationModel.fromJson(Map<String, dynamic> json) {
    return GetLocationModel(id: json["id"] as int, locationName: json["name"] as String);
  }

  final int id;
  final String locationName;

  Future<List<GetLocationModel>> getNames() async {
    languageCode();
    final List<GetLocationModel> locations = [];
    final response = await http.get(
      Uri.parse(
        "$authServerUrl/api/${lang ?? "ru"}/main-locations",
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        locations.add(GetLocationModel.fromJson(product));
      }
      return locations;
    } else {
      return null;
    }
  }

  Future makeComplaint({Map<String, dynamic> body, int realEstateID}) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.parse(
          "$authServerUrl/api/user/${lang ?? "ru"}/make-complaint/$realEstateID",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }
}

class GetMapArray extends ChangeNotifier {
  GetMapArray({this.id, this.lat, this.lng, this.name, this.price});

  factory GetMapArray.fromJson(Map<String, dynamic> json) {
    return GetMapArray(
      id: json["id"] as int,
      lat: json["lat"],
      lng: json["lng"],
      name: json["real_estate_name"] ?? "Gamyş",
      price: json["price"],
    );
  }

  final int id;
  final double lat;
  final double lng;
  final String name;
  final int price;

  Future<List<GetMapArray>> getRealEstatesPostion({Map<String, dynamic> parametrs}) async {
    final List<GetMapArray> locations = [];
    final response = await http.get(
      Uri.parse(
        "$authServerUrl/api/${lang ?? "ru"}/get-real-estate-positions",
      ).replace(queryParameters: parametrs),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        locations.add(GetMapArray.fromJson(product));
      }
      return locations;
    } else {
      return null;
    }
  }
}
