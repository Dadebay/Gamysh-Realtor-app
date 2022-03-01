// ignore_for_file: file_names, noop_primitive_operations, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final RefreshController _refreshController = RefreshController();
  String token = "";
  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    final token1 = await Auth().getToken();
    setState(() {
      token = token1;
      if (token1 != null) {
        RealEstatesModel().getFavoritedRealEstates();
        // myList.clear();
      }
    });
  }

  void _onRefresh() {
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          name: "favoritePageName".tr,
          backArrow: false,
        ),
        body: SmartRefresher(
          physics: const BouncingScrollPhysics(),
          primary: true,
          header: const MaterialClassicHeader(
            color: kPrimaryColor,
          ),
          footer: loadMore(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: FutureBuilder<List<RealEstatesModel>>(
              future: token == null ? RealEstatesModel().getFavoritedRealEstates() : RealEstatesModel().getFavoritedRealEstatesToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinKit());
                } else if (snapshot.data == null) {
                  return Center(
                    child: EmptyPage(
                      image: "assets/icons/svgIcons/favIcon.svg",
                      text: "emptyFavorite",
                      subtitle: "",
                      buttonText: "",
                      onTap: () {},
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: ConnectionError(buttonText: "", onTap: () {}));
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 1 : 2, mainAxisSpacing: 15, childAspectRatio: 9 / 11),
                      itemBuilder: (BuildContext context, int index) {
                        return RealEstateCard2(
                          name: snapshot.data[index].name,
                          addedRealEstate_Widget: false,
                          price: snapshot.data[index].price.toString(),
                          id: snapshot.data[index].id,
                          location: snapshot.data[index].location,
                          likedValue: true,
                          phone: snapshot.data[index].phoneNumber,
                          images: snapshot.data[index].images as List,
                        );
                      }),
                );
              }),
        ),
      ),
    );
  }
}
