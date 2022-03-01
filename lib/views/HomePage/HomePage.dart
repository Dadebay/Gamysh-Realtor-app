// ignore_for_file: file_names, require_trailing_commas, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamys/constants/constants.dart';
import 'package:get/get.dart';

import 'HomePageComponents/emlakGozlegi.dart';
import 'HomePageComponents/getRealEstates.dart';
import 'HomePageComponents/selectRegion.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white));

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset("assets/icons/pngIcons/logo.jpg", height: 35, width: 35),
              ),
              Text("Gamyş".tr, style: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 18)),
            ]),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectRegion(),
                emlakGozlegi(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    "homePageRealEtsateTitle".tr,
                    maxLines: 2,
                    style: TextStyle(fontFamily: robotoMedium, fontSize: 18, fontWeight: lang == "en" ? FontWeight.normal : FontWeight.bold),
                  ),
                ),
                GetRealEstatesHomePage(),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          )),
    );
  }
}
