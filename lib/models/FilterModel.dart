// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/FilterController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'RealEstatesModel.dart';
import 'UserModels/AuthModel.dart';

class FilterModel extends ChangeNotifier {
  final FilterController filterController = Get.put(FilterController());

  Future getSpecRealEstatesCount({Map<String, dynamic> parametrs}) async {
    languageCode();
    final response = await http.get(
      Uri.parse(
        "$serverURL/api/${lang ?? "ru"}/get-filter-count",
      ).replace(queryParameters: parametrs),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["count"];
      filterController.realEstateCount.value = double.parse(responseJson);
      filterController.buttomButtonBool.value = false;
      print(filterController.buttomButtonBool.value);

      return responseJson;
    } else {
      return null;
    }
  }

  Future<List<Specifications>> getSpecificationList({int categoryId, Map<String, String> parametrs}) async {
    languageCode();
    final List<Specifications> names = [];
    final response = await http.get(
        Uri.parse(
          "$authServerUrl/api/${lang ?? "ru"}/specifications-for-types/$categoryId",
        ).replace(queryParameters: parametrs),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"];

      if (responseJson != null) {
        for (final Map product in responseJson) {
          names.add(Specifications.fromJson(product));
        }
        if (names.length >= 4 && filterController.showAllFiltersSnapshot.value == false) {
          filterController.showAllFilters.value = true;
        } else {
          filterController.showAllFilters.value = false;
        }
        return names;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<RealEstatesModel>> getFilteredRealEstates({Map<String, dynamic> parametrs}) async {
    languageCode();
    final List<RealEstatesModel> realEstates = [];
    print(parametrs);
    final token = await Auth().getToken();
    final response = await http.get(
      Uri.parse(
        "$authServerUrl/api/${lang ?? "ru"}/all-real-estates",
      ).replace(queryParameters: parametrs),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["rows"][0]["real_estates_all"];
      final responseCount = jsonDecode(response.body)["rows"][0]["count"];
      if (responseJson != null) {
        pageNumber = int.parse(responseCount);
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
}
