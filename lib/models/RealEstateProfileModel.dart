// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:http/http.dart' as http;
import 'RealEstatesModel.dart';

class RealEstateProfileModel extends ChangeNotifier {
  RealEstateProfileModel(
      {this.fullName,
      this.userID,
      this.area,
      this.typeID,
      this.categoryID,
      this.description,
      this.position,
      this.createdAt,
      this.ownerType,
      this.price,
      this.location,
      this.name,
      this.images,
      this.userRealEstateCount,
      this.phoneNumber,
      this.specifications});

  factory RealEstateProfileModel.fromJson(Map<String, dynamic> json) {
    final List image = json["images"] as List;
    List<dynamic> _images;
    if (image == null) {
      _images = [""];
    } else {
      _images = image.map((value) => value).toList();
    }

    final List position = json["position"] as List;
    final List<dynamic> _position = position.map((value) => value).toList();
    return RealEstateProfileModel(
        area: json["area"] as String,
        price: json["price"] as String,
        description: json["description"] as String,
        createdAt: json["created_at"] as String,
        location: json["location"] as String,
        name: json["real_estate_name"] as String,
        phoneNumber: json["phone"] as String,
        typeID: json["type_id"] as int,
        categoryID: json["category_id"] as int,
        userRealEstateCount: json["user_real_estate_count"] as String,
        ownerType: json["owner_type"] as String,
        fullName: json['full_name'] as String,
        userID: json['user_id'] as String,
        images: _images,
        specifications: ((json['specifications'] ?? []) as List).map((json) => Specification.fromJson(json)).toList(),
        position: _position);
  }

  final String area;
  final String createdAt;
  final String description;
  final String fullName;
  var images;
  final String location;
  final String name;
  final String ownerType;
  final String phoneNumber;
  final int typeID;
  final int categoryID;
  var position;
  final String price;
  final List<Specification> specifications;
  final String userID;
  final String userRealEstateCount;

  Future<RealEstateProfileModel> getRealEstatesById(int id) async {
    languageCode();

    final response = await http.get(
        Uri.parse(
          "$serverURL/api/${lang ?? "ru"}/real-estate/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return RealEstateProfileModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return null;
    }
  }
}
