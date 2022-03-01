// ignore_for_file: unused_element, deprecated_member_use, file_names, depend_on_referenced_packages, must_be_immutable, always_declare_return_types, type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/controllers/UpdateRealEstateController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:gamys/models/UpdateModel.dart';
import 'package:gamys/views/AddRealEstatePage/MapPageSelectUserHouse.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:vibration/vibration.dart';
// import 'package:vibration/vibration.dart';
// // import 'package:vibration/vibration.dart';

import 'UpdateImageUpload.dart';

class UpdateReaLEstate extends StatelessWidget {
  final int id;

  UpdateReaLEstate({Key key, this.id}) : super(key: key);
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());
  final UpdateReaLEstateController updateReaLEstateController = Get.put(UpdateReaLEstateController());

  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  final AuthController authController = Get.put(AuthController());
  final UpdateReaLEstateController updateRealEstateController = Get.put(UpdateReaLEstateController());
  final GlobalKey<FormState> _form2Key = GlobalKey();
  FocusNode areaFocus = FocusNode();
  FocusNode descriptionRuFocus = FocusNode();
  FocusNode descriptionTmFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  TextEditingController areaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionTmController = TextEditingController();
  TextEditingController descriptionRuController = TextEditingController();
  TextEditingController locationController2 = TextEditingController();
  final List<TextEditingController> _controllers = [];

  myFunction(UpdateModel realEstate) {
    priceController.text = realEstate.price ?? "0 TMT";
    areaController.text = realEstate.area ?? "0.00";
    locationController2.text = realEstate.location ?? "Ashgabat";
    bottomNavBarController.currentUserLat2.value = realEstate.lat;
    bottomNavBarController.currentUserLong2.value = realEstate.lng;
    descriptionTmController.text = realEstate.descriptionTm ?? "error".tr;
    descriptionRuController.text = realEstate.descriptionRu ?? "error".tr;
    bottomNavBarController.mainLocationBig.value = realEstate.locationId;
    bottomNavBarController.mainLocationMini.value = realEstate.locationId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarToUse(),
      body: FutureBuilder<UpdateModel>(
          future: UpdateModel().updateGetRealEstate(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: Get.size.height,
                child: Center(child: spinKit()),
              );
            }
            Future.delayed(const Duration(milliseconds: 1), () {
              myFunction(snapshot.data);
              updateRealEstateController.updateValues.clear();
              bottomNavBarController.specList.clear();
              for (int i = 0; i < snapshot.data.specifications.length; i++) {
                bottomNavBarController.searchAndAddSpecList(
                    specID: snapshot.data.specifications[i].id,
                    id: snapshot.data.specifications[i].id,
                    isRequired: snapshot.data.specifications[i].isRequired,
                    isMultiple: snapshot.data.specifications[i].isMultiple,
                    values: [snapshot.data.specifications[i].values[0].valueId]);
                updateRealEstateController.updateValues.add({
                  "name": snapshot.data.specifications[i].name,
                  "value": snapshot.data.specifications[i].values[0].absoluteValue ?? snapshot.data.specifications[i].values[0].name,
                  "value_id": snapshot.data.specifications[i].values[0].valueId,
                });
              }
            });

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Form(
                      key: _form2Key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          if (snapshot.data.rejections != null)
                            Column(
                              children: [
                                Text(
                                  "${"rejectedReason".tr} :",
                                  style: const TextStyle(fontFamily: robotoMedium, color: Colors.black, fontSize: 18),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "${snapshot.data.rejections[snapshot.data.rejections.length - 1]["comment"]}",
                                    style: const TextStyle(fontFamily: robotoRegular, color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          else
                            const SizedBox.shrink(),
                          textField(textInputLength: 5, littleText: "litteTextM2".tr, text: "area".tr, errorText: "errorArea", controller: areaController, type: TextInputType.number, maxline: 1),
                          textField(textInputLength: 10, littleText: "TMT", text: "priсe".tr, errorText: "errorPrice", controller: priceController, type: TextInputType.number, maxline: 1),
                          selectLocation(),
                          if (snapshot.data.specifications.isNotEmpty)
                            FutureBuilder<List<Specifications>>(
                                future: Specifications().getSpecification(categoryId: snapshot.data.categoryID, typeId: snapshot.data.typeID),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: spinKit(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const SizedBox.shrink();
                                  } else if (snapshot.data.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  counter = 0;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return snapshot.data[index].isMultiple
                                          ? const Text("asd")
                                          // multipleSelectField(
                                          //     snapshot,
                                          //     index,
                                          //   )
                                          : onTapTextField(snapshot: snapshot, index: index);
                                    },
                                  );
                                })
                          else
                            const SizedBox.shrink(),
                          textField(textInputLength: 500, text: "descriptionTm".tr, errorText: "errorDescriptionRu", controller: descriptionTmController, type: TextInputType.text, maxline: 5),
                          textField(textInputLength: 500, text: "descriptionRu".tr, errorText: "errorDescriptionRu", controller: descriptionRuController, type: TextInputType.text, maxline: 5),
                          showOnMapButton(snapshot.data.lat, snapshot.data.lng),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: button(snapshot, id),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  MyAppBar appBarToUse() {
    return MyAppBar(
      name: "updateRealEstate",
      backArrow: true,
      widget: GestureDetector(
        onTap: () {
          Get.defaultDialog(
              title: "delete".tr,
              titleStyle: const TextStyle(color: Colors.black, fontFamily: robotoBold),
              titlePadding: const EdgeInsets.symmetric(vertical: 15),
              content: Text("deleteSubtitle".tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontFamily: robotoMedium)),
              radius: 4.0,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    GestureDetector(
                      onTap: () {
                        UpdateModel().deleteRealEstate(id).then((value) {
                          if (value == true) {
                            Get.to(() => BottomNavBar());
                            updateReaLEstateController.refreshPage();
                          } else {
                            showSnackBar("retry", "error", kPrimaryColor);
                          }
                        });
                      },
                      child: Text(
                        "yes".tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: robotoMedium,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text("no".tr, style: const TextStyle(color: kPrimaryColor, fontSize: 18, fontFamily: robotoMedium)),
                    ),
                  ]),
                )
              ]);
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(IconlyLight.delete, color: Colors.red),
        ),
      ),
    );
  }

  Padding selectLocation() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Stack(
          children: [
            Obx(() {
              return Positioned(
                  top: 1,
                  left: 0,
                  right: 0,
                  bottom: addRealEstateController.textFieldShadowBool.value == false ? 0 : 30,
                  child: Material(
                    elevation: 2,
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ));
            }),
            TextFormField(
              style: const TextStyle(fontFamily: robotoMedium),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "error".tr;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onTap: () {
                Get.defaultDialog(
                    title: "selectCity".tr,
                    radius: 5,
                    titleStyle: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 18),
                    titlePadding: const EdgeInsets.symmetric(vertical: 15),
                    content: Container(
                        width: 300,
                        height: 300,
                        color: Colors.white,
                        child: FutureBuilder<List<Region>>(
                            future: Region().getMainLocations(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    "error".tr,
                                    style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
                                  ),
                                );
                              } else if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: spinKit());
                              } else if (snapshot.data == null) {
                                return Center(
                                  child: Text(
                                    "retry".tr,
                                    style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      locationController2.text = snapshot.data[index].name;
                                      bottomNavBarController.mainLocationBig.value = snapshot.data[index].id;
                                      Get.back();
                                      Get.defaultDialog(
                                          title: "selectTown".tr,
                                          radius: 5,
                                          titleStyle: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 18),
                                          titlePadding: const EdgeInsets.symmetric(vertical: 15),
                                          content: Container(
                                              height: 300,
                                              width: 300,
                                              color: Colors.white,
                                              child: FutureBuilder<List<Region>>(
                                                  future: Region().getRegion(
                                                    index: bottomNavBarController.mainLocationBig.value,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Text(
                                                          "error".tr,
                                                          style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
                                                        ),
                                                      );
                                                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return Center(child: spinKit());
                                                    } else if (snapshot.data == null || snapshot.data.isEmpty) {
                                                      return Center(
                                                        child: Text(
                                                          "retry".tr,
                                                          style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
                                                        ),
                                                      );
                                                    }
                                                    return ListView.builder(
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            bottomNavBarController.mainLocationMini.value = snapshot.data[index].id;
                                                            locationController2.text += ", ${snapshot.data[index].name}";
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border(bottom: BorderSide(color: Colors.grey[300])),
                                                              ),
                                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(snapshot.data[index].name,
                                                                      maxLines: 2,
                                                                      style: const TextStyle(
                                                                        fontFamily: robotoRegular,
                                                                        fontSize: 16,
                                                                      )),
                                                                  const Icon(
                                                                    IconlyLight.arrowRightCircle,
                                                                    color: Colors.black,
                                                                  )
                                                                ],
                                                              )),
                                                        );
                                                      },
                                                    );
                                                  })));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(bottom: BorderSide(color: Colors.grey[300])),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data[index].name,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontFamily: robotoRegular,
                                                  fontSize: 16,
                                                )),
                                            const Icon(
                                              IconlyLight.arrowRightCircle,
                                              color: Colors.black,
                                            )
                                          ],
                                        )),
                                  );
                                },
                              );
                            })));
              },
              controller: locationController2,
              cursorColor: kPrimaryColor,
              readOnly: true,
              decoration: InputDecoration(
                constraints: const BoxConstraints(),
                label: Text("location".tr,
                    style: const TextStyle(
                      color: Colors.black87,
                    )),
                errorStyle: const TextStyle(color: Colors.red, fontFamily: robotoRegular),
                contentPadding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(fontFamily: robotoMedium, color: Colors.black87),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
              ),
            ),
          ],
        ));
  }

  int counter = 0;

  Padding onTapTextField({AsyncSnapshot snapshot, int index}) {
    if (counter < index) {
      counter++;
    }
    if (_controllers.length < snapshot.data.length) {
      _controllers.add(TextEditingController());
    }
    for (final element in updateRealEstateController.updateValues) {
      if (snapshot.data[index].name == element["name"]) {
        _controllers[counter].text = element["value"];
      }
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Stack(
          children: [
            Obx(() {
              return Positioned(
                  top: 1,
                  left: 0,
                  right: 0,
                  bottom: addRealEstateController.textFieldShadowBool.value == false ? 0 : 30,
                  child: Material(
                    elevation: 2,
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ));
            }),
            TextFormField(
              style: const TextStyle(fontFamily: robotoMedium),
              validator: snapshot.data[index].isRequired == true
                  ? (text) {
                      if (text == null || text.isEmpty) {
                        return "error".tr;
                      }
                      return null;
                    }
                  : null,
              textInputAction: TextInputAction.next,
              onTap: () {
                addRealEstateController.id.value = -1;
                final int length = snapshot.data[index].values.length;
                Get.defaultDialog(
                    radius: 4,
                    barrierDismissible: true,
                    actions: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                            onPressed: () {
                              addRealEstateController.id.value = 0;
                              Get.back();
                            },
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            elevation: 0,
                            child: Text("close".tr, style: const TextStyle(fontFamily: robotoMedium, fontSize: 16, color: Colors.grey))),
                      )
                    ],
                    titlePadding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                    title: "${snapshot.data[counter].name}",
                    titleStyle: const TextStyle(fontFamily: robotoMedium),
                    content: Container(
                      width: 300,
                      color: Colors.white,
                      height: length > 10 ? 300 : length * 50.0,
                      child: ListView.builder(
                          itemCount: length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int indexx) {
                            return
                                // Text("asd");
                                Obx(() {
                              return RadioListTile(
                                title: Text(snapshot.data[index].values[indexx]["name"] ?? snapshot.data[index].values[indexx]["absolute_value"],
                                    style: const TextStyle(fontFamily: robotoMedium, fontSize: 18)),
                                groupValue: addRealEstateController.id.value,
                                activeColor: kPrimaryColor,
                                selectedTileColor: kPrimaryColor,
                                value: indexx,
                                onChanged: (val) {
                                  addRealEstateController.id.value = indexx;
                                  _controllers[index].text = snapshot.data[index].values[indexx]["name"] ?? snapshot.data[index].values[indexx]["absolute_value"];
                                  bottomNavBarController.searchAndAddSpecList(
                                      specID: snapshot.data[index].specId,
                                      id: snapshot.data[index].specId,
                                      isRequired: snapshot.data[index].isRequired,
                                      isMultiple: snapshot.data[index].isMultiple,
                                      values: [snapshot.data[index].values[indexx]["value_id"]]);
                                  Get.back();
                                },
                              );
                            });
                          }),
                    ));
              },
              controller: _controllers[counter],
              cursorColor: kPrimaryColor,
              readOnly: true,
              decoration: InputDecoration(
                constraints: const BoxConstraints(),
                label: snapshot.data[index].isRequired == true
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data[index].name,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.star, color: Colors.red, size: 6),
                        ],
                      )
                    : Text(snapshot.data[index].name,
                        style: const TextStyle(
                          color: Colors.black87,
                        )),
                errorStyle: const TextStyle(color: Colors.red, fontFamily: robotoRegular),
                contentPadding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(fontFamily: robotoMedium, color: Colors.black87),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
              ),
            ),
          ],
        ));
  }

  SizedBox button(AsyncSnapshot snapshot, int id) {
    return SizedBox(
      width: Get.size.width,
      child: AgreeButton(
        name: "agree",
        color: kPrimaryColor,
        textColor: Colors.white,
        onTap: () {
          if (bottomNavBarController.currentUserLat2.value == 37.922252) {
            _form2Key.currentState.validate();
            addRealEstateController.textFieldShadowBool.value = true;
            showSnackBar("selectHouseLocation", "locationMyHouseError", kPrimaryColor);
            Vibration.vibrate();
          } else {
            if (_form2Key.currentState.validate()) {
              UpdateModel().updateRealEstate(body: {
                "area": areaController.text,
                "position": {"lng": bottomNavBarController.currentUserLong2.value, "lat": bottomNavBarController.currentUserLat2.value},
                "price": priceController.text,
                "location_id": bottomNavBarController.mainLocationMini.value ?? 1,
                "description_tm": descriptionTmController.text,
                "description_ru": descriptionRuController.text,
                "specifications": bottomNavBarController.specList
              }, id: snapshot.data.realEstateId).then((value) {
                if (value == 200) {
                  addRealEstateController.textFieldShadowBool.value = false;
                  updateReaLEstateController.myArray.clear();
                  for (int i = 0; i < snapshot.data.images.length; i++) {
                    updateReaLEstateController.myArray.add(false);
                  }
                  Get.to(() => UpdateImageUpload(
                        images: snapshot.data.images,
                        id: id,
                      ));
                  showSnackBar("updateTitle", "updateSubTitle", kPrimaryColor);
                } else if (value == 422) {
                  addRealEstateController.textFieldShadowBool.value = true;
                  showSnackBar("retry", "error404", kPrimaryColor);
                  Vibration.vibrate();
                } else {
                  addRealEstateController.textFieldShadowBool.value = true;
                  showSnackBar("retry", "error404", kPrimaryColor);
                  Vibration.vibrate();
                }
              });
            } else {
              addRealEstateController.textFieldShadowBool.value = true;
              showSnackBar("isNotEmpty", "fillStarTextFields", kPrimaryColor);
              Vibration.vibrate();
            }
          }
        },
      ),
    );
  }

  Padding textField({int textInputLength, String littleText, String text, String errorText, TextEditingController controller, TextInputType type, int maxline}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Stack(
        children: [
          Obx(() {
            return Positioned(
                top: 1,
                left: 0,
                right: 0,
                bottom: addRealEstateController.textFieldShadowBool.value == false
                    ? 0
                    : textInputLength > 10
                        ? 50
                        : 30,
                child: Material(
                  elevation: 2,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ));
          }),
          TextFormField(
            style: const TextStyle(fontFamily: robotoMedium),
            keyboardType: type,
            validator: (text) {
              if (textInputLength > 10 && text.length < 11) return "errorDescription".tr;
              if (text == null || text.isEmpty) {
                return errorText.tr;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            maxLines: maxline,
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(textInputLength),
            ],
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              suffixIcon: textInputLength == 9
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(littleText.tr, textAlign: TextAlign.center, style: TextStyle(fontFamily: robotoMedium, color: Colors.grey[500], fontSize: 14)),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              constraints: const BoxConstraints(),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.star, color: Colors.red, size: 6),
                ],
              ),
              errorStyle: const TextStyle(color: Colors.red, fontFamily: robotoRegular),
              contentPadding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
              filled: true,
              errorMaxLines: 2,
              fillColor: Colors.white,
              labelStyle: const TextStyle(fontFamily: robotoMedium, color: Colors.black87),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400])),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
            ),
          ),
        ],
      ),
    );
  }

  Padding multipleSelectField(AsyncSnapshot<List<Specifications>> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: MultiSelectDialogField(
        items: snapshot.data[index].values.map((e) => MultiSelectItem(e["name"].toString() ?? e["absolute_value"].toString(), e["name"].toString() ?? e["absolute_value"].toString())).toList(),
        title: Text(
          "choose".tr,
          style: const TextStyle(color: Colors.red, fontFamily: robotoMedium),
        ),
        selectedColor: kPrimaryColor,
        validator: (value) => value == null ? 'isNotEmpty'.tr : null,
        selectedItemsTextStyle: const TextStyle(color: Colors.white, fontFamily: robotoRegular),
        searchHint: "search".tr,
        searchHintStyle: const TextStyle(
          fontFamily: robotoMedium,
        ),
        searchTextStyle: const TextStyle(fontFamily: robotoRegular, color: Colors.black),
        searchIcon: const Icon(IconlyBroken.search),
        searchable: true,
        confirmText: Text("selectYes".tr, style: const TextStyle(fontFamily: robotoMedium, color: kPrimaryColor)),
        cancelText: Text("selectNo".tr, style: const TextStyle(fontFamily: robotoMedium, color: kPrimaryColor)),
        listType: MultiSelectListType.CHIP,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey[400],
            ),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, offset: const Offset(0, 0.4), blurRadius: 2, spreadRadius: 0.3)]),
        buttonIcon: const Icon(
          IconlyLight.arrowDownCircle,
          color: Colors.black,
        ),
        buttonText: snapshot.data[index].isRequired == true
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(snapshot.data[index].name,
                      style: const TextStyle(
                        color: Colors.black87,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.star, color: Colors.red, size: 6),
                ],
              )
            : Text(
                snapshot.data[index].name,
                style: const TextStyle(
                  fontFamily: robotoMedium,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
        onConfirm: (results) {
          final List myList = snapshot.data[index].values as List;
          final List myList2 = [];
          myList2.clear();
          for (final element in results) {
            for (final element2 in myList) {
              if (element == element2["name"]) {
                myList2.add(element2["value_id"]);
              }
            }
          }
          bottomNavBarController.searchAndAddSpecList(
              specID: snapshot.data[index].specId, id: snapshot.data[index].specId, isRequired: snapshot.data[index].isRequired, isMultiple: snapshot.data[index].isMultiple, values: myList2);
        },
      ),
    );
  }

  Column showOnMapButton(double lat, double long) {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            Get.to(() => MapPageSelectUserHouse());
          },
          color: Colors.white,
          disabledColor: Colors.white,
          elevation: 1,
          disabledElevation: 1,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey[400])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "selectHouseLocation".tr,
                style: const TextStyle(fontFamily: robotoMedium, color: Colors.black87),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                IconlyLight.arrowRightCircle,
                color: Colors.black,
              ),
            ],
          ),
        ),
        Container(
            width: Get.size.width,
            height: 200,
            margin: const EdgeInsets.only(bottom: 10),
            color: Colors.red,
            child: FlutterMap(
              options: MapOptions(
                onTap: ((tapPosition, point) {
                  Get.to(() => MapPageSelectUserHouse());
                }),
                pinchZoomThreshold: 0.1,
                center: latlong.LatLng(long, lat),
                // center: laLatLng(lat, long),
                maxZoom: 18.0,
              ),
              layers: [
                TileLayerOptions(backgroundColor: Colors.white, urlTemplate: "$serverMapImage/tile/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 25.0,
                      height: 25.0,
                      point: latlong.LatLng(long, lat),
                      // point: LatLng(lat, long),
                      builder: (ctx) => Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: const Icon(IconlyBold.profile, size: 18, color: Colors.white))),
                ]),
              ],
            ))
      ],
    );
  }
}
