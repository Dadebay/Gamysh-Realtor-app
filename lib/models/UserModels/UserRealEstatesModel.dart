// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:http/http.dart' as http;

import '../RealEstatesModel.dart';
import 'AuthModel.dart';

class UserRealEstateModel extends ChangeNotifier {
  UserRealEstateModel({this.id, this.statusId, this.price, this.location, this.wishList, this.name, this.images, this.isActive});

  factory UserRealEstateModel.fromJson(Map<String, dynamic> json) {
    final List image = json["images"] as List;
    List<dynamic> _images;
    if (image == null) {
      _images = [""];
    } else {
      _images = image.map((value) => value).toList();
    }

    return UserRealEstateModel(
        id: json["id"] as int,
        statusId: json["status_id"] as int,
        name: json["real_estate_name"] as String,
        price: json["price"] as String,
        isActive: json["is_active"],
        location: json["location"] as String,
        wishList: json["wish_list"],
        images: _images);
  }

  final int id;
  var images;
  final String location;
  final String name;
  final String price;
  final bool isActive;
  final int statusId;
  var wishList;

  Future<List<UserRealEstateModel>> getUserAddedRealEstates({
    Map<String, dynamic> parametrs,
  }) async {
    languageCode();

    final token = await Auth().getToken();
    final List<UserRealEstateModel> realEstates = [];
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/user/${lang ?? "ru"}/user-real-estates",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["real_estates"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          realEstates.add(UserRealEstateModel.fromJson(product));
        }

        return realEstates;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<RealEstatesModel>> getUserRealEstates({Map<String, String> parametrs, int id}) async {
    languageCode();
    final List<RealEstatesModel> realEstates = [];
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/${lang ?? "ru"}/user-real-estates/$id",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        realEstates.add(RealEstatesModel.fromJson(product));
      }
      return realEstates;
    } else {
      return null;
    }
  }

  Future deleteImage({int id}) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/${lang ?? "ru"}/delete-image/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      return "true";
    } else {
      return "false";
    }
  }
}
