// ignore_for_file: file_names, noop_primitive_operations, avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:get/get.dart';

final AuthController authController = Get.put(AuthController());

class GetRealEstatesHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RealEstatesModel>>(
        future: RealEstatesModel().getRealEstates(parametrs: {"page": "0", "limit": '10', "user_id": authController.userId.value}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: spinKit());
          } else if (snapshot.data == null) {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: EmptyPage(
                  image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                  text: "noAddedHousesTitle",
                  subtitle: "",
                  buttonText: "",
                  onTap: () {},
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: ConnectionError(buttonText: "", onTap: () {})),
            );
          }
          return GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 1 : 2, mainAxisSpacing: 15, childAspectRatio: 9 / 11),
              itemBuilder: (BuildContext context, int index) {
                return RealEstateCard2(
                  addedRealEstate_Widget: false,
                  ownerId: snapshot.data[index].ownerId,
                  name: snapshot.data[index].name,
                  price: snapshot.data[index].price.toString(),
                  id: snapshot.data[index].id,
                  location: snapshot.data[index].location,
                  phone: snapshot.data[index].phoneNumber,
                  vip: snapshot.data[index].vipTypeId == 1 ? true : false,
                  // vip: true,
                  likedValue: snapshot.data[index].wishList == null
                      ? false
                      : snapshot.data[index].wishList == 0
                          ? false
                          : true,
                  images: snapshot.data[index].images as List,
                );
              });
        });
  }
}
