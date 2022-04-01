// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis, require_trailing_commas
import 'dart:convert';
import 'dart:io';

import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:get/get.dart';
// import 'package:gamys/views/UpdateRealEstate/UpdateRealEstate.dart';
import 'package:http/http.dart' as http;

import 'AuthModel.dart';

final AuthController authController = Get.put(AuthController());

class UserSignInModel {
  UserSignInModel({this.name, this.phoneNumber, this.email, this.ownerId});

  factory UserSignInModel.fromJson(Map<String, dynamic> json) {
    return UserSignInModel(name: json["fullname"] as String, phoneNumber: json["phone"] as String, email: json["email"] as String, ownerId: json['owner_id'] as int);
  }

  final String email;
  final String name;
  final int ownerId;
  final String phoneNumber;

  Future signUp({String fullname, String phoneNumber, String password, String email, int realtor}) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/registration"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"full_name": fullname, "phone": phoneNumber, "password": password, "email": email, "owner_id": realtor}));
    print(response.body);
    if (response.statusCode == 200) {
      Auth().setToken(jsonDecode(response.body)["access_token"] as String);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future<UserSignInModel> otpVerfication({
    String code,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$authServerUrl/api/user/verify-code"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "code": code,
        }));
    if (response.statusCode == 200) {
      Auth().setToken(jsonDecode(response.body)["token"] as String);
      Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"] as String);
      final userIdData = jsonDecode(response.body)["data"];
      authController.userId.value = userIdData["id"];
      return UserSignInModel.fromJson(jsonDecode(response.body)["data"]);
    } else {
      return null;
    }
  }

  Future login({String phone, String password}) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/login"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "phone": phone,
          "password": password,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["access_token"];
      final userIdData = jsonDecode(response.body)["data"];
      authController.userId.value = userIdData["id"];
      if (responseJson == null) {
        Auth().setToken(jsonDecode(response.body)["token"] as String);
        Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"] as String);
        return response.statusCode;
      } else {
        Auth().setToken(jsonDecode(response.body)["access_token"] as String);
        return "smsgit";
      }
    } else {
      return response.statusCode;
    }
  }

  Future forgotPassword({
    String phoneNumber,
  }) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/forgot-password"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "phone": phoneNumber,
        }));
    if (response.statusCode == 200) {
      Auth().setToken(jsonDecode(response.body)["access_token"] as String);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }

  Future changePassword({
    String newPassword,
    String code,
  }) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$authServerUrl/api/user/change-password"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "password": newPassword,
          "code": code,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }
}
