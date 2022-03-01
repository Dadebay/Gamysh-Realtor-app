// ignore_for_file: deprecated_member_use, file_names, depend_on_referenced_packages, avoid_void_async, always_declare_return_types, type_annotate_public_apis, unnecessary_statements, unrelated_type_equality_checks

import 'dart:io';

import 'package:async/async.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
// import 'package:vibration/vibration.dart';
// // import 'package:vibration/vibration.dart';

class Page4 extends StatefulWidget {
  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  final AuthController authController = Get.put(AuthController());
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());

  final List<XFile> _imageFileList = [];
  final ImagePicker _picker = ImagePicker();

  void selectImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage(imageQuality: 25);
    if (selectedImages.length <= 15) {
      setState(() {
        final int a = selectedImages.length;
        final int b = _imageFileList.length;
        if (a + b <= 15) {
          if (b <= 15) {
            for (int i = 0; i < a; i++) {
              if (((File(selectedImages[i].path).readAsBytesSync().length / 1024) / 1024) < 1) {
                _imageFileList.add(selectedImages[i]);
                addRealEstateController.myArray.add(false);
              } else {
                showSnackBar("mbErrorTitle", "mbErrorSubtitle", kPrimaryColor);
                Vibration.vibrate();
              }
            }
          } else {
            showSnackBar("selectMoreImageTitle", "selectMoreImageSubtitle", kPrimaryColor);
            Vibration.vibrate();
          }
        } else {
          showSnackBar("selectMoreImageTitle", "selectMoreImageSubtitle", kPrimaryColor);
          Vibration.vibrate();
        }
      });
    } else {
      showSnackBar("selectMoreImageTitle", "selectMoreImageSubtitle", kPrimaryColor);
      Vibration.vibrate();
    }
  }

  bool addRealEstateValue = false;

  addRealEstate() async {
    authController.changeSignInAnimation();
    final String area = bottomNavBarController.textString[0];
    final String price = bottomNavBarController.textString[1];
    final String tm = bottomNavBarController.textString[2];
    final String ru = bottomNavBarController.textString[3];
    authController.changeSignInAnimation();
    languageCode();
    Specifications().addRealEstate(body: {
      "type_id": bottomNavBarController.typeID.value,
      "category_id": bottomNavBarController.categoryId.value,
      "area": area,
      "position": {"lng": bottomNavBarController.currentUserLong2.value, "lat": bottomNavBarController.currentUserLat2.value},
      "price": price,
      "location_id": bottomNavBarController.mainLocationMini.value,
      "description_tm": tm,
      "description_ru": ru,
      "specifications": bottomNavBarController.specList
    }).then((value) {
      if (value == 200) {
        addRealEstateController.textFieldShadowBool.value = false;
        uploadBig();
      } else if (value == 444) {
        addRealEstateController.textFieldShadowBool.value = true;
        authController.changeSignInAnimation();
        showSnackBar("maxJayGosdy", "maxJayGosdySubtitle", kPrimaryColor);
        Vibration.vibrate();
      } else {
        addRealEstateController.textFieldShadowBool.value = true;
        authController.changeSignInAnimation();
        showSnackBar("retry", "error404", kPrimaryColor);
        Vibration.vibrate();
      }
    });
  }

  uploadBig() {
    addRealEstateController.addedRealEstateId.value == 0 ? null : authController.changeSignInAnimation();
    for (int i = 0; i < _imageFileList.length; i++) {
      uploadImage(_imageFileList[i], i);
    }
  }

  int sum = 0;
  uploadImage(XFile file, int index) async {
    final uri = Uri.parse("$serverURL/api/user/${lang ?? "ru"}/add-real-estate-images/${addRealEstateController.addedRealEstateId.value}");
    final request = http.MultipartRequest("POST", uri);
    final String fileName = file.path.split("/").last;
    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();
    final mimeTypeData = lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');
    final multipartFileSign = http.MultipartFile('picture', stream, length, filename: fileName, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    request.files.add(multipartFileSign);
    final token = await Auth().getToken();
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    request.headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      addRealEstateController.myArray[index] = true;
      sum = 0;
      for (int j = 0; j < addRealEstateController.myArray.length; j++) {
        if (addRealEstateController.myArray[j] == true) {
          setState(() {
            sum++;
          });
        }
      }
      if (sum == addRealEstateController.myArray.length) {
        showSnackBar("imagesSendTitle", "imagesSendSubTitle", kPrimaryColor);
        authController.signInAnimation.value = false;
        bottomNavBarController.incrementPageIndex();
      }
    } else if (response.statusCode == 400) {
      addRealEstateController.myArray[index] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          width: Get.size.width,
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "selectImages".tr,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
            ),
            Text(
              "selectImagesCount".tr,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.grey[400], fontFamily: robotoRegular, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _imageFileList.isEmpty ? 1 : _imageFileList.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () async {
                          await Permission.camera.request();
                          await Permission.photos.request();
                          selectImages();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(6),
                            strokeWidth: 2,
                            color: kPrimaryColor,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: kPrimaryColor,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(borderRadius: borderRadius10),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            top: 10,
                            bottom: 5,
                            left: 5,
                            right: 10,
                            child: Material(
                              elevation: 2,
                              borderRadius: borderRadius10,
                              child: ClipRRect(
                                borderRadius: borderRadius10,
                                child: Image.file(File(_imageFileList[index - 1].path), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            top: 10,
                            bottom: 5,
                            left: 5,
                            right: 10,
                            child: Obx(() => Center(
                                  child: addRealEstateController.myArray[index - 1] == true
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.65),
                                            borderRadius: borderRadius10,
                                          ),
                                          child: Center(
                                              child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                                  child: const Icon(Icons.done, color: Colors.white, size: 25))),
                                        )
                                      : const SizedBox.shrink(),
                                )),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Obx(() => addRealEstateController.myArray[index - 1] == true
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _imageFileList.removeAt(index - 1);
                                          addRealEstateController.myArray.removeAt(index - 1);
                                        });
                                      },
                                      child: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.red)))),
                        ],
                      ),
                    );
                  }),
            ),
            // agreeButton2()
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AgreeButton(
                color: kPrimaryColor,
                textColor: Colors.white,
                name: "next",
                onTap: () {
                  if (_imageFileList.length < 4) {
                    showSnackBar("emptyImagesTitle", "emptyImagesSubtitle", kPrimaryColor);
                  } else {
                    if (authController.signInAnimation == false) addRealEstateController.addedRealEstateId.value == 0 ? addRealEstate() : uploadBig();
                  }
                },
              ),
            )
          ])),
    );
  }
}
