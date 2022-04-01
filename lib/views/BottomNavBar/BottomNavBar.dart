// ignore_for_file: missing_return, file_names, must_be_immutable, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:gamys/views/Auth/SignInPage.dart';
import 'package:gamys/views/HomePage/HomePage.dart';
import 'package:gamys/views/LastAddedRealEStatesPage/LastAddedRealEstates.dart';
import 'package:gamys/views/ProfilePage/ProfilePage.dart';
import 'package:get/get.dart';

import '../FavoritePage/FavoritePage.dart';
import 'Widgets.dart';

class BottomNavBar extends GetView<BottomNavBarController> {
  List page = [HomePage(), LastAddedRealEstatesPage(), Container(), FavoritePage(), ProfilePage()];
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: Colors.black,
            currentIndex: bottomNavBarController.selectedPageBottomIndex.value,
            onTap: (index) async {
              final token = await Auth().getToken();
              if (index == 2) {
                if (token == null) {
                  showSnackBar("login1".tr, "loginError".tr, kPrimaryColor);
                  Get.to(() => SignInPage());
                } else {
                  emlakGosmak2();
                }
              } else {
                bottomNavBarController.selectedIndex(index);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  IconlyLight.search,
                ),
                activeIcon: Icon(
                  IconlyLight.search,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.paper),
                activeIcon: Icon(IconlyBold.paper),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.plus),
                activeIcon: Icon(IconlyBold.plus),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.heart),
                activeIcon: Icon(IconlyBold.heart),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.profile),
                activeIcon: Icon(IconlyBold.profile),
                label: "",
              ),
            ],
          );
        }),
        body: Obx(() {
          return page[bottomNavBarController.selectedPageBottomIndex.value] as Widget;
        }));
  }
}
