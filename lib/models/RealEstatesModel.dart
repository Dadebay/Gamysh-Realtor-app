// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis, require_trailing_commas

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:http/http.dart' as http;

import 'UserModels/AuthModel.dart';

class RealEstatesModel extends ChangeNotifier {
  RealEstatesModel({this.id, this.price, this.location, this.ownerId, this.vipTypeId, this.name, this.images, this.phoneNumber, this.wishList});

  factory RealEstatesModel.fromJson(Map<String, dynamic> json) {
    final List image = json["images"] as List;
    List<dynamic> _images;
    if (image == null) {
      _images = [""];
    } else {
      _images = image.map((value) => value).toList();
    }

    return RealEstatesModel(
      id: json["id"] as int,
      name: json["real_estate_name"] as String,
      price: json["price"] as String,
      location: json["location"] as String,
      phoneNumber: json["phone"] as String,
      wishList: json["wish_list"],
      ownerId: json["owner_id"],
      vipTypeId: json["vip_type_id"],
      images: _images,
    );
  }

  final int id;
  var images;
  final String location;
  final String name;
  final int ownerId;
  final String phoneNumber;
  final String price;
  final int vipTypeId;
  var wishList;

  Future<List<RealEstatesModel>> getRealEstates({Map<String, dynamic> parametrs}) async {
    languageCode();

    final List<RealEstatesModel> realEstates = [];
    final response = await http.get(
      Uri.parse(
        "$serverURL/api/${lang ?? "ru"}/all-real-estates",
      ).replace(queryParameters: parametrs),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["real_estates_all"];
      final responseCount = jsonDecode(response.body)["rows"][0]["count"];
      pageNumber = int.parse(responseCount as String);
      if (responseJson != null) {
        for (final Map product in responseJson) {
          realEstates.add(RealEstatesModel.fromJson(product));
        }
        return realEstates;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<RealEstatesModel>> getFavoritedRealEstates() async {
    languageCode();
    final List<RealEstatesModel> realEstates = [];

    final response = await http.post(
        Uri.parse(
          "$serverURL/api/${lang ?? "ru"}/get-wish-list",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "real_estates": myList,
        }));
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["real_estates_all"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          realEstates.add(RealEstatesModel.fromJson(product));
        }
        return realEstates;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<RealEstatesModel>> getFavoritedRealEstatesToken() async {
    languageCode();
    final List<RealEstatesModel> realEstates = [];
    final token = await Auth().getToken();

    final response = await http.get(
      Uri.parse(
        "$serverURL/api/user/${lang ?? "ru"}/get-wish-list",
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"]["real_estates_all"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          realEstates.add(RealEstatesModel.fromJson(product));
        }
        return realEstates;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<RealEstatesModel>> getHistoryView() async {
    languageCode();
    if (historyView.length > 10) {
      historyView.removeRange(0, historyView.length - 10);
    }

    final List myListHistory = historyView.reversed.toList();
    final List<RealEstatesModel> realEstates = [];
    final response = await http.post(
        Uri.parse(
          "$serverURL/api/${lang ?? "ru"}/get-history-view",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "real_estates": myListHistory,
        }));
    if (response.statusCode == 200) {
      if (response.body == null || response.body.isEmpty || response.body.isEmpty) {
        return null;
      } else {
        final responseJson = jsonDecode(response.body)["rows"]["real_estates_all"];
        for (final Map product in responseJson) {
          realEstates.add(RealEstatesModel.fromJson(product));
        }

        return realEstates;
      }
    } else {
      return null;
    }
  }

  Future addFavorite(int realEstateID) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(
      Uri.parse(
        "$serverURL/api/user/${lang ?? "ru"}/add-to-wish-list/$realEstateID",
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }

  Future removeFavorite(int realEstateId) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(
      Uri.parse(
        "$serverURL/api/user/${lang ?? "ru"}/remove-from-wish-list/$realEstateId",
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }
}

class Specification {
  Specification({this.name, this.values});

  factory Specification.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Specification(
      name: json['name'] as String,
      values: ((json['values'] ?? []) as List).map((json) => Values.fromJson(json)).toList(),
    );
  }

  final String name;
  final List<Values> values;
}

class Values {
  Values({this.name, this.valueId, this.absoluteValue});

  factory Values.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Values(name: json['name'] as String, valueId: json['value_id'], absoluteValue: json["absolute_value"] as String);
  }

  final String absoluteValue;
  final String name;
  final int valueId;
}
