// ignore_for_file: depend_on_referenced_packages, file_names, avoid_void_async, always_declare_return_types, type_annotate_public_apis, deprecated_member_use, use_build_context_synchronously

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
import 'package:gamys/controllers/UpdateRealEstateController.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:gamys/models/UserModels/UserRealEstatesModel.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:gamys/views/UpdateRealEstate/MyRealEstates.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:vibration/vibration.dart';
// import 'package:vibration/vibration.dart';
// // import 'package:vibration/vibration.dart';

class UpdateImageUpload extends StatefulWidget {
  final List images;
  final int id;
  const UpdateImageUpload({Key key, this.images, this.id}) : super(key: key);
  @override
  State<UpdateImageUpload> createState() => _UpdateImageUploadState();
}

class _UpdateImageUploadState extends State<UpdateImageUpload> {
  final AuthController authController = Get.put(AuthController());
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  final UpdateReaLEstateController updateReaLEstateController = Get.put(UpdateReaLEstateController());
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());
  final List<File> _imageFileToSend = [];
  List myList = [];

  int sumOfImages = 0;
  @override
  void initState() {
    super.initState();
    sumOfImages = 0;
    myList = widget.images;
    sumOfImages = myList.length;
  }

  final ImagePicker _picker = ImagePicker();

  void selectImages() async {
    final selectedImages = await _picker.pickMultiImage(imageQuality: 25);
    if (selectedImages.length <= 15) {
      setState(() {
        final int a = selectedImages.length;
        final int b = _imageFileToSend.length;
        if (a + b <= 15) {
          if (b <= 15) {
            for (int i = 0; i < a; i++) {
              if (((File(selectedImages[i].path).readAsBytesSync().length / 1024) / 1024) < 1) {
                _imageFileToSend.add(File(selectedImages[i].path));
                myList.add({"id": 0, "destination": File(selectedImages[i].path)});
                updateReaLEstateController.myArray.add(false);
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

  uploadBig() {
    authController.changeSignInAnimation();
    if (_imageFileToSend.isEmpty) {
      for (int i = 0; i < widget.images.length; i++) {
        Future.delayed(const Duration(seconds: 3), () {
          updateReaLEstateController.myArray[i] = true;
        });
      }
      Future.delayed(const Duration(seconds: 5), () {
        authController.signInAnimation.value = false;
        showSnackBar("imagesSendTitle", "imagesSendSubTitle", kPrimaryColor);
        updateReaLEstateController.refreshPage();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BottomNavBar()));
      });
    } else {
      if (myList.isNotEmpty) {
        for (int i = 0; i < widget.images.length; i++) {
          Future.delayed(const Duration(seconds: 3), () {
            updateReaLEstateController.myArray[i] = true;
          });
        }
        for (int i = 0; i < _imageFileToSend.length; i++) {
          upload(_imageFileToSend[i], i);
        }
      } else {
        for (int i = 0; i < _imageFileToSend.length; i++) {
          upload(_imageFileToSend[i], i);
        }
      }
    }
  }

  int sum = 0;

  upload(File file, int index) async {
    languageCode();
    final uri = Uri.parse("$serverImage/api/user/${lang ?? "ru"}/add-real-estate-images/${widget.id}");
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
      updateReaLEstateController.myArray[index] = true;
      sum = 0;
      for (int j = 0; j < updateReaLEstateController.myArray.length; j++) {
        if (updateReaLEstateController.myArray[j] == true) {
          setState(() {
            sum++;
          });
        }
      }
      if (sum == updateReaLEstateController.myArray.length) {
        showSnackBar("imagesSendTitle", "imagesSendSubTitle", kPrimaryColor);
        authController.signInAnimation.value = false;
        updateReaLEstateController.refreshPage();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BottomNavBar()));
      }
    } else if (response.statusCode == 400) {
      updateReaLEstateController.myArray[index] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            color: Colors.white,
            width: Get.size.width,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
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
                    itemCount: myList.length + 1,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () {
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
                                  child: index >= sumOfImages + 1
                                      ? Image.file(File(_imageFileToSend[(index - sumOfImages) - 1].path), fit: BoxFit.cover)
                                      : Image.network("$serverImage/${myList[index - 1]['destination']}-mini.webp"),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                top: 10,
                                bottom: 5,
                                left: 5,
                                right: 10,
                                child: Center(
                                    child: Obx(() => updateReaLEstateController.myArray[index - 1] == false
                                        ? const SizedBox.shrink()
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.65),
                                              borderRadius: borderRadius10,
                                            ),
                                            child: Center(
                                                child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                                    child: const Icon(Icons.done, color: Colors.white, size: 25))),
                                          )))),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Obx(() => updateReaLEstateController.myArray[index - 1] == true
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        if ((_imageFileToSend.length + myList.length) > 4) {
                                          if (index - 1 >= sumOfImages) {
                                            setState(() {
                                              myList.removeLast();
                                              sumOfImages = myList.length;
                                              _imageFileToSend.removeWhere((element) => element == _imageFileToSend[(index - sumOfImages) - 1]);
                                              updateReaLEstateController.myArray.removeLast();
                                            });
                                          } else {
                                            UserRealEstateModel().deleteImage(id: myList[index - 1]["id"]).then((value) {
                                              if (value == "true") {
                                                setState(() {
                                                  sumOfImages = myList.length;
                                                  myList.removeWhere((element) => element["id"] == myList[index - 1]["id"]);
                                                  updateReaLEstateController.myArray.removeAt(index - 1);
                                                });
                                              } else {
                                                showSnackBar("errorSnapshot", "error", kPrimaryColor);
                                              }
                                            });
                                          }
                                        } else {
                                          showSnackBar("error", "cannotDeleteSubtitle", kPrimaryColor);
                                        }
                                      },
                                      child: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.red))),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              AgreeButton(
                name: "agree",
                color: kPrimaryColor,
                textColor: Colors.white,
                onTap: () {
                  uploadBig();
                },
              ),
              Container(
                width: Get.size.width,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    updateReaLEstateController.refreshPage();
                    Get.to(() => MyRealEstates());
                  },
                  child: Text(
                    "skip".tr,
                    style: const TextStyle(color: kPrimaryColor, fontSize: 20, fontFamily: robotoMedium),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
