// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'UserModels/AuthModel.dart';

class RealEstateTypes extends ChangeNotifier {
  RealEstateTypes({this.id, this.name});

  factory RealEstateTypes.fromJson(Map<String, dynamic> json) {
    return RealEstateTypes(id: json["id"] as int, name: json["name"].toString());
  }

  int id;
  String name;

  Future<List<RealEstateTypes>> getTypes({int categoryId, int typeId}) async {
    languageCode();
    final List<RealEstateTypes> names = [];
    final response = await http.get(
        Uri.parse(
          "$authServerUrl/api/${lang ?? "ru"}/types/$categoryId/$typeId",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        names.add(RealEstateTypes.fromJson(product));
      }
      return names;
    } else {
      return null;
    }
  }
}

class Region extends ChangeNotifier {
  Region({this.id, this.name});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(id: json["id"] as int, name: json["name"].toString());
  }

  int id;
  String name;

  Future<List<Region>> getMainLocations() async {
    languageCode();
    final List<Region> names = [];
    final response = await http.get(
        Uri.parse(
          "$authServerUrl/api/${lang ?? "ru"}/main-locations/",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        names.add(Region.fromJson(product));
      }
      return responseJson.length > 0 != null ? names : null;
    } else {
      return null;
    }
  }

  Future<List<Region>> getRegion({int index}) async {
    languageCode();
    final List<Region> names = [];
    final response = await http.get(
        Uri.parse(
          "$authServerUrl/api/${lang ?? "ru"}/region-locations/$index",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty && response.body != null) {
        final responseJson = jsonDecode(response.body)["rows"];
        for (final Map product in responseJson) {
          names.add(Region.fromJson(product));
        }
        return names;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

class Specifications extends ChangeNotifier {
  Specifications({this.specId, this.isMultiple, this.isRequired, this.name, this.values});

  factory Specifications.fromJson(Map<String, dynamic> json) {
    List _values = [];

    if (json["values"] != null) {
      final List value = json["values"] as List;
      _values = value.map((value) => value).toList();
    }
    return Specifications(specId: json["specification_id"] as int, isMultiple: json["is_multiple"] as bool, isRequired: json["is_required"] as bool, name: json["name"].toString(), values: _values);
  }

  bool isMultiple;
  bool isRequired;
  String name;
  int specId;
  var values;
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());

  Future<List<Specifications>> getSpecification({int typeId, int categoryId}) async {
    languageCode();
    final List<Specifications> names = [];
    final response = await http.get(
        Uri.parse(
          "$authServerUrl/api/${lang ?? "ru"}/specifications-for-type/$typeId/$categoryId",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      for (final Map product in responseJson) {
        names.add(Specifications.fromJson(product));
      }
      return responseJson.length > 0 != null ? names : null;
    } else {
      return null;
    }
  }

  Future addRealEstate({Map<String, dynamic> body}) async {
    languageCode();
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$authServerUrl/api/user/${lang ?? "ru"}/add-real-estate"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      addRealEstateController.changeAddedRealEstateId(responseJson["id"]);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}

class TypeIDValues extends ChangeNotifier {
  TypeIDValues({
    this.id,
    this.name,
    this.mainTypes,
  });

  factory TypeIDValues.fromJson(Map<String, dynamic> json) {
    return TypeIDValues(id: json["id"] as int, name: json["name"].toString(), mainTypes: ((json['main_types'] ?? []) as List).map((json) => MainTypes.fromJson(json)).toList());
  }

  final int id;
  final List<MainTypes> mainTypes;
  final String name;

  Future<List<TypeIDValues>> getCategoryTypes() async {
    languageCode();
    final List<TypeIDValues> names = [];
    final response = await http.get(
        Uri.parse(
          "$authServerUrl/api/${lang ?? "ru"}/categories-types",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];
      if (responseJson != null) {
        for (final Map product in responseJson) {
          names.add(TypeIDValues.fromJson(product));
        }
        return names;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

class MainTypes {
  MainTypes({this.name, this.id, this.subTypes});

  factory MainTypes.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return MainTypes(name: json['name'] as String, id: json['id'] as int, subTypes: ((json['sub_types'] ?? []) as List).map((json) => SubTypes.fromJson(json)).toList());
  }

  final int id;
  final String name;
  final List<SubTypes> subTypes;
}

class SubTypes {
  SubTypes({this.name, this.id});

  factory SubTypes.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return SubTypes(name: json['name'] as String, id: json["id"] as int);
  }

  final int id;
  final String name;
}
