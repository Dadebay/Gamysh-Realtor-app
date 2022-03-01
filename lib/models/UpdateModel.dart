// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:http/http.dart' as http;

import 'UserModels/AuthModel.dart';

class UpdateModel extends ChangeNotifier {
  UpdateModel(
      {this.realEstateId,
      this.descriptionTm,
      this.locationId,
      this.descriptionRu,
      this.isActive,
      this.typeID,
      this.categoryID,
      this.lat,
      this.rejections,
      this.lng,
      this.area,
      this.location,
      this.price,
      this.images,
      this.specifications});

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    final List image = json["images"] as List;
    final List rejections = json["rejections"] as List;
    List<dynamic> _images;
    if (image == null) {
      _images = [""];
    } else {
      _images = image.map((value) => value).toList();
    }
    return UpdateModel(
      realEstateId: json["real_estate_id"],
      area: json["area"],
      price: json["price"],
      locationId: json["location_id"],
      location: json["location"],
      descriptionTm: json["description_tm"],
      descriptionRu: json["description_ru"],
      lat: json["lat"],
      lng: json["lng"],
      isActive: json["is_active"],
      rejections: rejections,
      typeID: json["type_id"],
      categoryID: json["category_id"],
      images: _images,
      specifications: ((json['specifications'] ?? []) as List).map((json) => SpecificationUpdate.fromJson(json)).toList(),
    );
  }
  final int realEstateId;
  final int locationId;
  final String area;
  final String price;
  final String descriptionTm;
  final String descriptionRu;
  final bool isActive;
  final int typeID;
  final String location;
  final int categoryID;
  final double lat;
  final double lng;
  var rejections;
  var images;
  final List<SpecificationUpdate> specifications;

  Future<UpdateModel> updateGetRealEstate(int id) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/user/${lang ?? "ru"}/user-real-estate/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      return UpdateModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return null;
    }
  }

  Future deleteRealEstate(int id) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/${lang ?? "ru"}/remove-real-estate/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }

  Future updateRealEstate({Map<String, dynamic> body, int id}) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/${lang ?? "ru"}/update-real-estate/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return null;
    }
  }
}

class SpecificationUpdate {
  SpecificationUpdate({this.name, this.isMultiple, this.isRequired, this.id, this.values});

  factory SpecificationUpdate.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return SpecificationUpdate(
      id: json["id"],
      name: json['name'] as String,
      isMultiple: json["is_multiple"],
      isRequired: json["is_required"],
      values: ((json['values'] ?? []) as List).map((json) => Values.fromJson(json)).toList(),
    );
  }

  final String name;
  final bool isMultiple;
  final bool isRequired;
  final int id;
  final List<Values> values;
}
