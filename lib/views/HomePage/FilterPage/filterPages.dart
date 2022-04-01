// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, invalid_use_of_protected_member, unused_local_variable, avoid_bool_literals_in_conditional_expressions, unnecessary_parenthesis, deprecated_member_use, non_constant_identifier_names

import 'dart:convert';
import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/controllers/FilterController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:gamys/models/FilterModel.dart';
import 'package:gamys/models/GetLocation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'FilteredRealEstates.dart';

class FilterPages extends StatefulWidget {
  @override
  State<FilterPages> createState() => _FilterPagesState();
}

TextEditingController areaTextEditingControllerMax = TextEditingController();
TextEditingController areaTextEditingControllerMin = TextEditingController();
TextEditingController priceTextEditingControllerMax = TextEditingController();
TextEditingController priceTextEditingControllerMin = TextEditingController();
Future getTypeIDValues;

class _FilterPagesState extends State<FilterPages> {
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  final FilterController filterController = Get.put(FilterController());

  @override
  void initState() {
    super.initState();
    getTypeIDValues = TypeIDValues().getCategoryTypes();
    filterController.choiceChipList.clear();
    filterController.specListMine.clear();
    filterController.typeIdListaArray.clear();
    filterController.typeIdList.clear();
    filterController.realtorID.value = 3;
    priceTextEditingControllerMax.clear();
    priceTextEditingControllerMin.clear();
    areaTextEditingControllerMin.clear();
    areaTextEditingControllerMax.clear();
    filterController.showAllFiltersSnapshot.value == false;
    getRealEstateCount();
  }

  Page1() {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          Widget1(),
          dividerr(),
          Widget2(),
          Widget3(),
          Widget4(),
          filterController.tabbarIndex.value == 1
              ? SizedBox(
                  height: 30,
                )
              : SizedBox.shrink(),
          Spesifications(),
          filterController.showAllFilters.value
              ? SizedBox.shrink()
              : twoTextEditingField(
                  name: "price".tr,
                  name2: "TMT",
                  hintText1: "dan1".tr,
                  hintText2: "dan2".tr,
                  controller1: priceTextEditingControllerMin,
                  controller2: priceTextEditingControllerMax,
                ),
          filterController.showAllFilters.value
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 25, bottom: filterController.showAllFiltersSnapshot.value ? 20 : 120),
                  child: twoTextEditingField(
                    name: "area".tr,
                    name2: "litteTextM2".tr,
                    hintText1: "dan1".tr,
                    hintText2: "dan2".tr,
                    controller1: areaTextEditingControllerMin,
                    controller2: areaTextEditingControllerMax,
                  ),
                ),
          filterController.showAllFilters.value ? showAllFiltersButton() : SizedBox.shrink(),
          filterController.showAllFiltersSnapshot.value ? hideallFiltersButton() : SizedBox.shrink(),
        ],
      ),
    );
  }

  showAllFiltersButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 80),
      alignment: Alignment.center,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 20),
        onPressed: () {
          filterController.showAllFilters.value = false;
          filterController.showAllFiltersSnapshot.value = true;
        },
        highlightColor: Colors.white,
        highlightElevation: 0,
        hoverColor: Colors.white,
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "moreSpec".tr,
              style: const TextStyle(color: kPrimaryColor, fontSize: 18, fontFamily: robotoMedium),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowDownCircle, color: kPrimaryColor, size: 24),
            )
          ],
        ),
      ),
    );
  }

  hideallFiltersButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 80),
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          filterController.showAllFilters.value = true;
          filterController.showAllFiltersSnapshot.value = false;
        },
        highlightColor: Colors.white,
        highlightElevation: 0,
        hoverColor: Colors.white,
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "moreSpecHide".tr,
              style: const TextStyle(color: kPrimaryColor, fontSize: 18, fontFamily: robotoMedium),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(IconlyLight.arrowUpCircle, color: kPrimaryColor, size: 24),
            )
          ],
        ),
      ),
    );
  }

  Widget Spesifications() {
    return FutureBuilder<List<Specifications>>(
        future: FilterModel().getSpecificationList(categoryId: bottomNavBarController.categoryId.value, parametrs: {
          "type_id": "${filterController.typeIdListaArray}",
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: spinKit(),
            ));
          } else if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filterController.showAllFilters.value ? 3 : snapshot.data.length,
              itemBuilder: (BuildContext context, int indexx) {
                if (indexx < snapshot.data.length) {
                  Future.delayed(const Duration(milliseconds: 1), () async {
                    filterController.addChoiceChipList(snapshot, indexx);
                  });
                }
                return specCard(snapshot, indexx);
              },
            );
          });
        });
  }

  Wrap specCard(AsyncSnapshot<List<Specifications>> snapshot, int indexx) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
          child: Text("${snapshot.data[indexx].name ?? "Filter"}:", style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
        ),
        SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data[indexx].values.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: spinKit(),
                ));
              } else if (snapshot.hasError) {
                return const SizedBox.shrink();
              } else if (snapshot.data == null) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () {
                  if (filterController.choiceChipList[indexx]["list"][index]["value"] == false) {
                    filterController.choiceChipList[indexx]["list"][index]["value"] = true;
                  } else {
                    filterController.choiceChipList[indexx]["list"][index]["value"] = false;
                  }
                  filterController.choiceChipList.refresh();
                  bool mine = false;
                  bool mine2 = false;
                  for (final element in filterController.specListMine) {
                    if (element["id"] == snapshot.data[indexx].specId) {
                      mine = true;
                      element["values"].forEach((element2) {
                        if (element2 == snapshot.data[indexx].values[index]["value_id"]) {
                          mine2 = true;
                          filterController.removeSpecListItem(snapshot.data[indexx].values[index]["value_id"], snapshot.data[indexx].specId);
                        }
                      });
                      if (mine2 == false) {
                        element["values"].add(snapshot.data[indexx].values[index]["value_id"]);
                      }
                    }
                  }
                  if (mine == false) {
                    filterController.specListMine.add({
                      "id": snapshot.data[indexx].specId,
                      "values": [snapshot.data[indexx].values[index]["value_id"]]
                    });
                  }
                  getRealEstateCount();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Obx(() {
                    bool value;
                    String name;
                    if (filterController.choiceChipList.isEmpty) {
                      value = false;
                    } else {
                      value = filterController.choiceChipList[indexx]["list"][index]["value"] ?? false;
                    }
                    if (snapshot.data[indexx].values[index]["absolute_value"] != null) {
                      name = snapshot.data[indexx].values[index]["absolute_value"];
                    } else if (snapshot.data[indexx].values[index]["name"] != null) {
                      name = snapshot.data[indexx].values[index]["name"];
                    } else {
                      name = "Gamyş";
                    }
                    return Chip(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      label: Center(
                        child: Text(
                          name,
                          style: TextStyle(fontFamily: value == false ? robotoRegular : robotoMedium, color: Colors.black, fontSize: 16),
                        ),
                      ),
                      backgroundColor: value == false ? backgroundColor : kPrimaryColor.withOpacity(0.2),
                      shape: const RoundedRectangleBorder(borderRadius: borderRadius20),
                    );
                  }),
                ),
              );
            },
          ),
        ),

        // chipList(snapshot.data[index].values as List, snapshot.data[index].specId, index) as Widget
      ],
    );
  }

  TabBar TabbarMine() {
    return TabBar(
      indicatorColor: kPrimaryColor,
      indicatorWeight: 3.0,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      onTap: (int a) {
        filterController.tabbarIndex.value = a;
        filterController.typeIdListaArray.clear();
        for (final element in filterController.typeIdList) {
          element["value"] = false;
        }
        for (final element in filterController.typeIdList2) {
          element["value"] = false;
        }
        if (a == 0) {
          filterController.typeId.value = 3;
        }
        if (a == 1) {
          filterController.typeId.value = 8;
        }
        getRealEstateCount();
      },
      labelStyle: const TextStyle(color: Colors.black, fontFamily: robotoMedium),
      tabs: [
        Tab(
          child: Container(
            height: Get.size.height,
            width: Get.size.width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: Center(
              child: Text(
                "sell1".tr,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: robotoMedium),
              ),
            ),
          ),
        ),
        Tab(
          child: Container(
            height: Get.size.height,
            width: Get.size.width,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "sell2".tr,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: robotoMedium),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding Widget2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Obx(() {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaisedButton(
              onPressed: () {
                bottomNavBarController.selectedCategoryId(1);
                TypeIDValues().getCategoryTypes();
                getRealEstateCount();
              },
              elevation: 0,
              highlightElevation: 0,
              padding: const EdgeInsets.all(10),
              disabledColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: borderRadius5,
              ),
              color: bottomNavBarController.categoryId.value == 1 ? backgroundColor : Colors.white,
              child: Text(
                "sell3".tr,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            RaisedButton(
              onPressed: () {
                bottomNavBarController.selectedCategoryId(2);
                getRealEstateCount();

                TypeIDValues().getCategoryTypes();
              },
              elevation: 0,
              highlightElevation: 0,
              padding: const EdgeInsets.all(10),
              disabledColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: borderRadius5,
              ),
              color: bottomNavBarController.categoryId.value == 2 ? backgroundColor : Colors.white,
              child: Text(
                "rent1".tr,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Padding Widget3() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: Obx(() {
        return CheckboxListTile(
          title: Text(
            "iamOwner2".tr,
            style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool value) {
            if (value == true) {
              filterController.realtorID.value = 1;
            } else {
              filterController.realtorID.value = 2;
            }
            getRealEstateCount();
          },
          contentPadding: EdgeInsets.zero,
          checkColor: Colors.white,
          activeColor: kPrimaryColor,
          value: filterController.realtorID.value == 1 ? true : false,
          // value: filterController.realtorID.value == 1 ? true : false,
        );
      }),
    );
  }

  Widget Widget1() {
    return Obx(() {
      return ListTile(
        onTap: () {
          Get.bottomSheet(
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("selectRegion".tr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: robotoBold,
                            )),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(CupertinoIcons.xmark, color: Colors.black)),
                      ],
                    ),
                  ),
                  dividerr(),
                  dividerr(),
                  FutureBuilder<List<GetLocationModel>>(
                      future: GetLocationModel().getNames(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 35),
                            child: spinKit(),
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 35),
                            child: Text("errorQuickSearch".tr, style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18)),
                          ));
                        } else if (snapshot.data == null) {
                          return Expanded(
                              child: Center(
                            child: EmptyPage(
                              image: "assets/icons/svgIcons/File_cracked.svg",
                              text: "error",
                              subtitle: "",
                              buttonText: "retry",
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ));
                        }
                        return Expanded(
                            child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                bottomNavBarController.changeName(snapshot.data[index].locationName);
                                filterController.changegetLocationID(snapshot.data[index].id);
                                getRealEstateCount();
                                Get.back();
                              },
                              child: Container(
                                width: Get.size.width,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child: Text(
                                  snapshot.data[index].locationName,
                                  style: const TextStyle(fontFamily: robotoMedium, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ));
                      })
                ],
              ),
            ),
          );
        },
        title: Text("  ${bottomNavBarController.locationName}", style: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 16)),
        leading: const Icon(IconlyBold.location, size: 26, color: Colors.black54),
        trailing: const Icon(IconlyLight.arrowRight2, size: 20, color: Colors.black54),
      );
    });
  }

  FutureBuilder Widget4() {
    return FutureBuilder<List<TypeIDValues>>(
      future: getTypeIDValues,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("typeOfRealEstate".tr, style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
                ),
                Text("loading".tr),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("typeOfRealEstate".tr, style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
                ),
                Text("loading".tr),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else if (snapshot.data == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("typeOfRealEstate".tr, style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
                ),
                Text("loading".tr),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          if (filterController.tabbarIndex.value == 0) {
            if (filterController.typeIdList.value.isEmpty || filterController.typeIdList.value.isEmpty || filterController.typeIdList.value == []) {
              filterController.typeIdList.clear();
              for (int i = 0; i < snapshot.data[filterController.tabbarIndex.value].mainTypes[filterController.tabbarIndex.value].subTypes.length; i++) {
                if (filterController.typeIdList.length < snapshot.data[filterController.tabbarIndex.value].mainTypes[filterController.tabbarIndex.value].subTypes.length) {
                  final int a = snapshot.data[filterController.tabbarIndex.value].mainTypes[filterController.tabbarIndex.value].subTypes[i].id;
                  filterController.addTypeIdList(a, false);
                }
              }
            }
          } else {
            if (filterController.typeIdList2.value.isEmpty || filterController.typeIdList2.value.isEmpty || filterController.typeIdList2.value == []) {
              filterController.typeIdList2.clear();
              for (int i = 0; i < snapshot.data[1].mainTypes[1].subTypes.length; i++) {
                if (filterController.typeIdList2.length < snapshot.data[1].mainTypes[1].subTypes.length) {
                  filterController.addTypeIdList2(snapshot.data[1].mainTypes[1].subTypes[i].id, false);
                }
              }
            }
          }
          Future.delayed(Duration(milliseconds: 0), () {
            if (filterController.typeIdListaArray.isEmpty && filterController.tabbarIndex.value == 0) {
              filterController.typeIdList[0]["value"] = true;
              filterController.typeIdListaArray.add(snapshot.data[0].mainTypes[0].subTypes[0].id);
              filterController.specListMine.clear();
              getRealEstateCount();
            }
          });
          return filterController.tabbarIndex.value == 0
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20),
                        child: Text("typeOfRealEstate".tr, style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
                      ),
                      SizedBox(
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data[0].mainTypes[0].subTypes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                filterController.showAllFiltersSnapshot.value = false;
                                filterController.showAllFilters.value = false;
                                filterController.updateTypeIdList(snapshot.data[0].mainTypes[0].subTypes[index].id);
                                if (filterController.typeIdListaArray.isEmpty) {
                                  filterController.typeIdListaArray.add(snapshot.data[0].mainTypes[0].subTypes[index].id);
                                } else {
                                  bool valueMine = false;
                                  for (final element in filterController.typeIdListaArray) {
                                    if (element == snapshot.data[0].mainTypes[0].subTypes[index].id) {
                                      valueMine = true;
                                    }
                                  }
                                  if (valueMine == true) {
                                    filterController.removeElement(snapshot.data[0].mainTypes[0].subTypes[index].id);
                                  } else {
                                    filterController.typeIdListaArray.add(snapshot.data[0].mainTypes[0].subTypes[index].id);
                                  }
                                  for (final element in filterController.choiceChipList.value) {
                                    element["list"].forEach((element) {
                                      element["value"] = false;
                                    });
                                  }
                                }
                                filterController.specListMine.clear();
                                getRealEstateCount();
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Obx(() {
                                    return Chip(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      label: Text(
                                        snapshot.data[0].mainTypes[0].subTypes[index].name ?? "a",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: filterController.typeIdList[index]["value"] == false ? robotoRegular : robotoMedium, color: Colors.black, fontSize: 15),
                                      ),
                                      backgroundColor: filterController.typeIdList[index]["value"] == false ? backgroundColor : kPrimaryColor.withOpacity(0.3),
                                      shape: const RoundedRectangleBorder(borderRadius: borderRadius20),
                                    );
                                  })),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                      child: Text("typeOfRealEstate".tr, style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Obx(() {
                            return CheckboxListTile(
                              value: filterController.typeIdList2[index]["value"],
                              tileColor: Colors.white,
                              activeColor: kPrimaryColor,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (bool value) {
                                filterController.updateTypeIdList2(snapshot.data[1].mainTypes[1].subTypes[index].id);
                                if (filterController.typeIdListaArray.isEmpty) {
                                  filterController.typeIdListaArray.add(snapshot.data[1].mainTypes[1].subTypes[index].id);
                                } else {
                                  bool valueMine2 = false;
                                  for (final element in filterController.typeIdListaArray) {
                                    if (element == snapshot.data[1].mainTypes[1].subTypes[index].id) {
                                      valueMine2 = true;
                                    }
                                  }
                                  if (valueMine2 == true) {
                                    filterController.removeElement(snapshot.data[1].mainTypes[1].subTypes[index].id);
                                  } else {
                                    filterController.typeIdListaArray.add(snapshot.data[1].mainTypes[1].subTypes[index].id);
                                  }
                                }
                                for (final element in filterController.choiceChipList.value) {
                                  element["list"].forEach((element) {
                                    element["value"] = false;
                                  });
                                }
                                getRealEstateCount();
                              },
                              title: Text(
                                snapshot.data[1].mainTypes[1].subTypes[index].name,
                                style: const TextStyle(fontFamily: robotoMedium),
                              ),
                            );
                          });
                        },
                        itemCount: snapshot.data[filterController.tabbarIndex.value].mainTypes[filterController.tabbarIndex.value].subTypes.length,
                        // shrinkWrap: true,
                      ),
                    ),
                  ],
                );
        }
        return const Text("asddddd");
      },
    );
  }

  Padding twoTextEditingField({String name, String hintText1, String hintText2, String name2, TextEditingController controller1, TextEditingController controller2}) {
    String formNum(String s) {
      return NumberFormat.decimalPattern().format(
        int.parse(s),
      );
    }

    String formNum2(String s) {
      return NumberFormat.decimalPattern().format(
        int.parse(s),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(name, style: TextStyle(fontFamily: robotoRegular, fontSize: 17, color: Colors.grey[400])),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(fontFamily: robotoRegular, fontSize: 18),
                  cursorColor: kPrimaryColor,
                  controller: controller1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onChanged: (string) {
                    if (name2 == "TMT") {
                      string = '${formNum(
                        string.replaceAll('a', ''),
                      )}';
                      controller1.value = TextEditingValue(
                        text: string,
                        selection: TextSelection.collapsed(
                          offset: string.length,
                        ),
                      );
                    }
                    getRealEstateCount();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(name2 == "TMT" ? 9 : 6),
                  ],
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    isDense: true,
                    prefixIcon: Text("$hintText1 ", style: const TextStyle(fontFamily: robotoRegular, fontSize: 16, color: Colors.black)),
                    prefixIconConstraints: const BoxConstraints(
                      maxWidth: 40,
                    ),
                    suffixIcon: Text(name2, style: const TextStyle(fontFamily: robotoRegular, fontSize: 16, color: Colors.black)),
                    suffixIconConstraints: const BoxConstraints(
                      maxWidth: 40,
                    ),
                    hintStyle: const TextStyle(fontFamily: robotoRegular, fontSize: 18, color: Colors.black),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(fontFamily: robotoRegular, fontSize: 18),
                  cursorColor: kPrimaryColor,
                  controller: controller2,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(name2 == "TMT" ? 9 : 6),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (string) {
                    if (name2 == "TMT") {
                      string = '${formNum2(
                        string.replaceAll('a', ''),
                      )}';
                      controller2.value = TextEditingValue(
                        text: string,
                        selection: TextSelection.collapsed(
                          offset: string.length,
                        ),
                      );
                    }
                    getRealEstateCount();
                  },
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    prefixIcon: Text("$hintText2 ", style: const TextStyle(fontFamily: robotoRegular, fontSize: 16, color: Colors.black)),
                    prefixIconConstraints: const BoxConstraints(
                      maxWidth: 40,
                    ),
                    isDense: true,
                    suffixIcon: Text(name2, style: const TextStyle(fontFamily: robotoRegular, fontSize: 16, color: Colors.black)),
                    suffixIconConstraints: const BoxConstraints(
                      maxWidth: 40,
                    ),
                    hintStyle: const TextStyle(fontFamily: robotoRegular, fontSize: 18, color: Colors.black),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 1.0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.xmark, color: kPrimaryColor),
        iconSize: 22,
        onPressed: () {
          Get.back();
        },
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Text(
        "filter".tr,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: robotoMedium),
      ),
    );
  }

  getRealEstateCount() {
    filterController.buttomButtonBool.value = true;
    print(filterController.realtorID.value);

    FilterModel().getSpecRealEstatesCount(parametrs: {
      "main_type_id": "${filterController.tabbarIndex.value + 1}",
      "category_id": "${bottomNavBarController.categoryId.value}",
      "type_id": json.encode(filterController.typeIdListaArray),
      "owner_id": filterController.realtorID.value == 3 ? "" : "${filterController.realtorID.value}",
      "price": json.encode({"min": priceTextEditingControllerMin.text, "max": priceTextEditingControllerMax.text}),
      "area": json.encode({"min": areaTextEditingControllerMin.text, "max": areaTextEditingControllerMax.text}),
      "location_id": "${filterController.locationId.value}",
      "spec_values": json.encode(filterController.specListMine),
      "user_id": "${filterController.realtorID.value}",
    });
  }

  Widget bottomButton() {
    return Container(
        padding: const EdgeInsets.only(left: 35),
        width: Get.size.width,
        child: RaisedButton(
          color: kPrimaryColor,
          disabledColor: kPrimaryColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          onPressed: () {
            final String priceMin = priceTextEditingControllerMin.text.isEmpty ? null : priceTextEditingControllerMin.text;
            final String priceMax = priceTextEditingControllerMax.text.isEmpty ? null : priceTextEditingControllerMax.text;
            final String areaMin = areaTextEditingControllerMin.text.isEmpty ? null : areaTextEditingControllerMin.text;
            final String areaMax = areaTextEditingControllerMax.text.isEmpty ? null : areaTextEditingControllerMax.text;
            final price = json.encode({"min": priceMin, "max": priceMax});
            final area = json.encode({"min": areaMin, "max": areaMax});
            priceTextEditingControllerMax.clear();
            priceTextEditingControllerMin.clear();
            areaTextEditingControllerMin.clear();
            filterController.list.clear();

            areaTextEditingControllerMax.clear();
            Get.to(
              () => FilteredRealEstates(
                mainTypeId: filterController.tabbarIndex.value + 1,
                specValues: filterController.specListMine,
                realtorID: filterController.realtorID.value,
                categoryId: bottomNavBarController.categoryId.value,
                typeId: filterController.typeIdListaArray.value,
                locationId: filterController.locationId.value,
                area: area,
                price: price,
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Get.locale.languageCode == "en")
                Obx(() {
                  return filterController.buttomButtonBool.value
                      ? Container(
                          height: 23,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: SpinKitWave(
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : Countup(
                          begin: 0,
                          end: filterController.realEstateCount.value,
                          duration: const Duration(milliseconds: 500),
                          separator: ',',
                          style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 18),
                        );
                })
              else
                const SizedBox.shrink(),
              Text(
                Get.locale.languageCode == "ru" ? "${"see".tr} " : " ${"see".tr}",
                style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 18),
              ),
              if (Get.locale.languageCode == "ru")
                Obx(() {
                  return filterController.buttomButtonBool.value
                      ? Container(
                          height: 23,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: SpinKitWave(
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : Countup(
                          begin: 0,
                          end: filterController.realEstateCount.value,
                          duration: const Duration(milliseconds: 500),
                          separator: ',',
                          style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 18),
                        );
                })
              else
                const SizedBox.shrink(),
              Text(
                Get.locale.languageCode == "ru" ? " ${"see2".tr}  " : " ${"see2".tr}",
                style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 18),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return DefaultTabController(
          length: 2,
          initialIndex: filterController.tabbarIndex.value,
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: bottomButton(),
            appBar: appBar(),
            body: Column(
              children: [
                TabbarMine(),
                dividerr(),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Page1() as Widget,
                      Page1() as Widget,
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
