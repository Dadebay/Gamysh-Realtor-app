// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:get/get.dart';

import "package:latlong2/latlong.dart" as latlong;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:vibration/vibration.dart';
import 'MapPageSelectUserHouse.dart';

// ignore: must_be_immutable
class Page3 extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());

  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  final GlobalKey<FormState> _form2Key = GlobalKey();
  TextEditingController areaController = TextEditingController();
  TextEditingController descriptionRuController = TextEditingController();
  TextEditingController descriptionTmController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode areaFocus = FocusNode();
  FocusNode descriptionRuFocus = FocusNode();
  FocusNode descriptionTmFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  List<dynamic> animal = [];
  final List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: Get.size.width,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Text(
            "addRealEstate".tr,
            style: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _form2Key,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    textField(textInputLength: 5, littleText: "litteTextM2".tr, text: "area".tr, errorText: "errorArea", controller: areaController, type: TextInputType.number, maxline: 1),
                    textField(textInputLength: 10, littleText: "TMT", text: "priсe".tr, errorText: "errorPrice", controller: priceController, type: TextInputType.number, maxline: 1),
                    FutureBuilder<List<Specifications>>(
                        future: Specifications().getSpecification(typeId: bottomNavBarController.typeID.value, categoryId: bottomNavBarController.categoryId.value),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox.shrink();
                          } else if (snapshot.connectionState == ConnectionState.waiting) {
                            // return SizedBox.shrink();
                            return Center(child: spinKit());
                          } else if (snapshot.data == null) {
                            return const SizedBox.shrink();
                          }
                          counter = 0;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              animal = snapshot.data[index].values as List<dynamic>;
                              return snapshot.data[index].isMultiple ? multipleSelectField(snapshot, index) : onTapTextField(snapshot: snapshot, index: index);
                            },
                          );
                        }),
                    textField(textInputLength: 500, text: "descriptionTm".tr, errorText: "errorDescriptionRu", controller: descriptionTmController, type: TextInputType.text, maxline: 5),
                    textField(textInputLength: 500, text: "descriptionRu".tr, errorText: "errorDescriptionRu", controller: descriptionRuController, type: TextInputType.text, maxline: 5),
                    showOnMapButton(),
                    agreeButton2()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int counter = 0;
  Padding onTapTextField({
    AsyncSnapshot snapshot,
    int index,
  }) {
    if (counter < index) {
      counter++;
    }
    if (_controllers.length < snapshot.data.length) {
      _controllers.add(TextEditingController());
    }
    // _controllers.add(new TextEditingController());
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
                final int a = snapshot.data[index].values.length;
                Get.defaultDialog(
                    radius: 4,
                    barrierDismissible: true,
                    actions: [
                      Align(
                        alignment: Alignment.bottomRight,
                        // ignore: deprecated_member_use
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
                    title: "${snapshot.data[index].name}",
                    titleStyle: const TextStyle(fontFamily: robotoMedium),
                    content: SizedBox(
                      width: 300,
                      height: a > 7 ? 300 : a * 50.0,
                      child: ListView.builder(
                          itemCount: snapshot.data[index].values.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int indexx) {
                            final String name = snapshot.data[index].values[indexx]["name"] == null
                                ? snapshot.data[index].values[indexx]["absolute_value"].toString()
                                : snapshot.data[index].values[indexx]["name"].toString();
                            return Obx(() {
                              return RadioListTile(
                                title: Text(name, style: const TextStyle(fontFamily: robotoMedium, fontSize: 18)),
                                groupValue: addRealEstateController.id.value,
                                activeColor: kPrimaryColor,
                                selectedTileColor: kPrimaryColor,
                                value: indexx,
                                onChanged: (val) {
                                  addRealEstateController.id.value = indexx;
                                  _controllers[index].text = name;
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
              controller: _controllers[index],
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

  Padding textField({
    int textInputLength,
    String littleText,
    String text,
    String errorText,
    TextEditingController controller,
    TextInputType type,
    int maxline,
  }) {
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
                  color: Colors.red,
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
        items: animal.map((e) => MultiSelectItem(e["name"].toString() ?? e["absolute_value"].toString(), e["name"].toString() ?? e["absolute_value"].toString())).toList(),
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

  Widget agreeButton2() {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          authController.changeSignInAnimation();
          if (bottomNavBarController.currentUserLat2.value == 37.922252) {
            _form2Key.currentState.validate();
            addRealEstateController.textFieldShadowBool.value = true;
            authController.changeSignInAnimation();
            showSnackBar("selectHouseLocation", "locationMyHouseError", kPrimaryColor);
            Vibration.vibrate();
          } else {
            if (_form2Key.currentState.validate()) {
              bottomNavBarController.incrementPageIndex();
              addRealEstateController.textFieldShadowBool.value = true;
              bottomNavBarController.textString.clear();
              bottomNavBarController.textString.add(areaController.text);
              bottomNavBarController.textString.add(priceController.text);
              bottomNavBarController.textString.add(descriptionTmController.text);
              bottomNavBarController.textString.add(descriptionRuController.text);
              authController.changeSignInAnimation();
              addRealEstateController.addedRealEstateId.value = 0;
            } else {
              addRealEstateController.textFieldShadowBool.value = true;
              showSnackBar("isNotEmpty", "fillStarTextFields", kPrimaryColor);
              authController.changeSignInAnimation();
              Vibration.vibrate();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: PhysicalModel(
            elevation: 1,
            borderRadius: borderRadius10,
            color: kPrimaryColor,
            child: AnimatedContainer(
              decoration: const BoxDecoration(
                borderRadius: borderRadius10,
                color: kPrimaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              curve: Curves.ease,
              width: authController.signInAnimation.value ? 70 : Get.size.width,
              duration: const Duration(milliseconds: 1000),
              child: authController.signInAnimation.value
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      "agree".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontFamily: robotoMedium, color: Colors.white),
                    ),
            ),
          ),
        ),
      );
    });
  }

  Column showOnMapButton() {
    return Column(
      children: [
        // ignore: deprecated_member_use
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
          child: Obx(() {
            return FlutterMap(
              options: MapOptions(
                onTap: ((tapPosition, point) {
                  Get.to(() => MapPageSelectUserHouse());
                }),
                pinchZoomThreshold: 0.1,
                center: latlong.LatLng(bottomNavBarController.currentUserLat2.value, bottomNavBarController.currentUserLong2.value),
                zoom: addRealEstateController.currentZoom.value,
                maxZoom: 18.0,
              ),
              layers: [
                TileLayerOptions(backgroundColor: Colors.white, urlTemplate: "$serverMapImage/tile/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 25.0,
                      height: 25.0,
                      point: latlong.LatLng(bottomNavBarController.currentUserLat2.value, bottomNavBarController.currentUserLong2.value),
                      builder: (ctx) => Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: const Icon(IconlyBold.profile, size: 18, color: Colors.white))),
                ]),
              ],
            );
          }),
        )
      ],
    );
  }
}
