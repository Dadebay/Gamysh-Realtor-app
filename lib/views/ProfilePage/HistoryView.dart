// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, noop_primitive_operations, avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:get/get.dart';

class HistoryView extends StatefulWidget {
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  // final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          name: "historyView".tr,
          backArrow: true,
          widget: GestureDetector(
              onTap: () {
                setState(() {
                  historyView.clear();
                });
              },
              child: historyView.isNotEmpty ? Text("clear".tr, style: const TextStyle(color: kPrimaryColor, fontFamily: robotoMedium)) : const SizedBox.shrink())),
      body: FutureBuilder<List<RealEstatesModel>>(
          future: RealEstatesModel().getHistoryView(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: ConnectionError(buttonText: "", onTap: () {}));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: spinKit());
            } else if (snapshot.data == null) {
              return Center(
                child: EmptyPage(
                  image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                  text: "historyViewEmpty",
                  subtitle: "",
                  buttonText: "",
                  onTap: () {},
                ),
              );
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
                      addedRealEstate_Widget: false,
                      name: snapshot.data[index].name,
                      price: snapshot.data[index].price.toString(),
                      id: snapshot.data[index].id,
                      location: snapshot.data[index].location,
                      // ignore: avoid_bool_literals_in_conditional_expressions
                      likedValue: snapshot.data[index].wishList == null
                          ? false
                          : snapshot.data[index].wishList == 0
                              ? false
                              : true,
                      phone: snapshot.data[index].phoneNumber,
                      images: snapshot.data[index].images as List,
                    );
                  }),
            );
          }),
    );
  }
}
