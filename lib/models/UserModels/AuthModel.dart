// ignore_for_file: file_names, require_trailing_commas
import 'dart:convert';
import 'dart:io';

import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/ProfilPageController.dart';
import 'package:gamys/views/Auth/LoginPage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  SharedPreferences _prefs;

  Future loginUser({String phone, String password}) async {
    final response = await http.post(Uri.parse("$authServerUrl/api/user/login"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "phone": phone,
          "password": password,
        }));
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["data"];
      Auth().setToken(jsonDecode(response.body)["access_token"] as String);
      Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"] as String);
      Auth().login(name: responseJson["name"] as String, uid: responseJson["id"] as int, phone: responseJson["user"] as String, gmail: responseJson["email"] as String);
      return true;
    } else {
      return false;
    }
  }

  Future deleteUser({int id}) async {
    final token = await Auth().getToken();
    final response = await http.post(
      Uri.parse("$authServerUrl/api/user/ru/delete-myself/$id"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future refreshToken() async {
    final refreshToken = await Auth().getRefreshToken();
    final response = await http.post(Uri.parse("$authServerUrl/api/user/refresh"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "refresh_token": refreshToken,
        }));
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body)["data"];
      Auth().setToken(jsonDecode(response.body)["access_token"] as String);
      Auth().setRefreshToken(jsonDecode(response.body)["refresh_token"] as String);
      Auth().login(name: responseJson["name"] as String, uid: responseJson["id"] as int, phone: responseJson["user"] as String, gmail: responseJson["email"] as String);
      return true;
    } else {
      Get.to(() => LoginInPage());
    }
  }

  Future<bool> login({String name, int uid, String phone, String gmail}) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('name', name);
    await _prefs.setInt('uid', uid);
    await _prefs.setString('phone', phone);
    await _prefs.setString('gmail', gmail);
    return _prefs.setBool("isLoggedIn", true);
  }

  Future<bool> logout() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("name");
    await _prefs.remove("uid");
    await _prefs.remove("gmail");
    await _prefs.remove("phone");
    return _prefs.setBool("isLoggedIn", false);
  }

  final ProfilePageController profilePageController = Get.put(ProfilePageController());

  /////////////////////////////////////////User Token///////////////////////////////////
  Future<bool> setToken(String token) async {
    profilePageController.changeCustomToken(token);

    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }

  Future<bool> removeToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.remove('token');
  }

  /////////////////////////////////////////User Token///////////////////////////////////
/////////////////////////////////////////User Refresh Token///////////////////////////////////

  Future<bool> setRefreshToken(String token) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('refreshtoken', token);
  }

  Future<String> getRefreshToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('refreshtoken');
  }

  Future<bool> removeRefreshToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.remove('refreshtoken');
  }
}
