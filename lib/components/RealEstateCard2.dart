// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, deprecated_member_use, non_constant_identifier_names, require_trailing_commas

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/ProfilPageController.dart';
import 'package:gamys/controllers/RealEstatesController.dart';
import 'package:gamys/controllers/UpdateRealEstateController.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:gamys/views/HomePage/HomePageComponents/getRealEstates.dart';
import 'package:gamys/views/RealEstateProfil.dart/RealEstateProfil.dart';
import 'package:gamys/views/UpdateRealEstate/UpdateRealEstate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProfilePageController profilePageController = Get.put(ProfilePageController());

List<String> buttonName = [
  'call'.tr,
  'share'.tr,
];
call(String phoneNumber) async {
  // await FlutterPhoneDirectCaller.callNumber("+993$phoneNumber");
}

bool liked = false;
int selectedIndex = 0;
final RealEstatesController realEstatesController = Get.put(RealEstatesController());

class RealEstateCard2 extends StatefulWidget {
  const RealEstateCard2(
      {Key key, this.name, this.vip, this.price, this.ownerId = 0, this.id, this.location, this.phone, this.addedRealEstate_Text, this.addedRealEstate_Widget, this.images, this.likedValue})
      : super(key: key);

  final int id;
  final String addedRealEstate_Text;
  final bool addedRealEstate_Widget;
  final bool vip;
  final List images;
  final String location;
  final String name;
  final String phone;
  final String price;
  final bool likedValue;
  final int ownerId;

  @override
  State<RealEstateCard2> createState() => _RealEstateCard2State();
}

class _RealEstateCard2State extends State<RealEstateCard2> {
  final UpdateReaLEstateController updateReaLEstateController = Get.put(UpdateReaLEstateController());

  @override
  void initState() {
    super.initState();
    liked = widget.likedValue;
    selectedIndex = 0;
  }

  addFavorite() async {
    bool favRealEstate = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMap = json.encode(myList);
    final token = await Auth().getToken();

    for (final element in myList) {
      if (element == widget.id) {
        favRealEstate = true;
      }
    }

    if (favRealEstate == false) {
      myList.add(widget.id);
      setState(() {
        liked = true;
      });
      token == null
          ? showSnackBar("addedFavoriteTitle", "addedFavoriteSubtitle", kPrimaryColor)
          : RealEstatesModel().addFavorite(widget.id).then((value) {
              if (value == true) showSnackBar("addedFavoriteTitle", "addedFavoriteSubtitle", kPrimaryColor);
            });
    } else {
      removeFavorite();
    }
    prefs.setString('cart', encodedMap);
  }

  removeFavorite() async {
    final token = await Auth().getToken();
    myList.removeWhere((element) => element == widget.id);

    if (token != null) {
      RealEstatesModel().removeFavorite(widget.id).then((value) {
        if (value == true) {
          showSnackBar("removeFavoriteTitle", "removeFavoriteSubtitle", kPrimaryColor);
          setState(() {
            liked = false;
          });
        } else {
          showSnackBar("retry", "error404", kPrimaryColor);
        }
      });
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedMap = json.encode(myList);
      setState(() {
        liked = false;
      });
      showSnackBar("removeFavoriteTitle", "removeFavoriteSubtitle", kPrimaryColor);
      prefs.setString('cart', encodedMap);
    }
  }

  Widget imagePart() {
    final String name = widget.addedRealEstate_Text == "2"
        ? "sold".tr
        : widget.addedRealEstate_Text == "4"
            ? "rent".tr
            : widget.addedRealEstate_Text == "null"
                ? "waiting".tr
                : widget.addedRealEstate_Text == "true"
                    ? "active".tr
                    : "rejected".tr;
    return Expanded(
        child: Container(
      color: Colors.grey[200],
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                  flex: 2,
                  child: widget.images.length > 1
                      ? Stack(
                          children: [
                            CarouselSlider.builder(
                                itemCount: widget.images.length,
                                itemBuilder: (BuildContext context, int index, int realIndex) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.addedRealEstate_Widget == true) {
                                        authController.signInAnimation.value = false;
                                        updateReaLEstateController.myArray.clear();

                                        Get.to(() => UpdateReaLEstate(
                                              id: widget.id,
                                            ));
                                      } else {
                                        Get.to(() => RealEstateProfil(
                                              id: widget.id,
                                              name: widget.name,
                                              price: widget.price,
                                            ));
                                        if (historyView.isEmpty) {
                                          historyView.add(widget.id);
                                        } else {
                                          bool value = false;
                                          for (final element in historyView) {
                                            if (element == widget.id) {
                                              value = true;
                                            }
                                          }
                                          if (value == false) historyView.add(widget.id);
                                        }
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      child: CachedNetworkImage(
                                        colorBlendMode: BlendMode.difference,
                                        imageUrl: "$serverImage/${widget.images[selectedIndex]['destination']}-big.webp",
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(child: spinKit()),
                                        errorWidget: (context, url, error) => GestureDetector(
                                            onTap: () {
                                              if (widget.addedRealEstate_Widget == true) {
                                                authController.signInAnimation.value = false;
                                                updateReaLEstateController.myArray.clear();

                                                Get.to(() => UpdateReaLEstate(
                                                      id: widget.id,
                                                    ));
                                              } else {
                                                Get.to(() => RealEstateProfil(
                                                      id: widget.id,
                                                      name: widget.name,
                                                      price: widget.price,
                                                    ));
                                                if (historyView.isEmpty) {
                                                  historyView.add(widget.id);
                                                } else {
                                                  bool value = false;
                                                  for (final element in historyView) {
                                                    if (element == widget.id) {
                                                      value = true;
                                                    }
                                                  }
                                                  if (value == false) historyView.add(widget.id);
                                                }
                                              }
                                            },
                                            child: const Icon(Icons.error_outline)),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                  onPageChanged: (int a, CarouselPageChangeReason) {
                                    setState(() {
                                      selectedIndex = a;
                                    });
                                  },
                                  viewportFraction: 1,
                                  height: Get.size.height,
                                )),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Text(
                                "${selectedIndex + 1}/${widget.images.length}",
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: robotoBold),
                              ),
                            ),
                          ],
                        )
                      : noImage()),
              dividerr(),
              dividerr(),
              if (widget.images.length > 1)
                Expanded(
                  child: Row(
                    children: [
                      miniImage("$serverImage/${widget.images[widget.images.length - 1]['destination']}-big.webp"),
                      const VerticalDivider(
                        color: Colors.white,
                        width: 1,
                        thickness: 1,
                      ),
                      miniImage("$serverImage/${widget.images[widget.images.length ~/ 2]['destination']}-big.webp"),
                      const VerticalDivider(
                        color: Colors.white,
                        width: 1,
                        thickness: 1,
                      ),
                      miniImage(
                        "$serverImage/${widget.images[0]['destination']}-big.webp",
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        width: 1,
                        thickness: 1,
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
          if (widget.addedRealEstate_Widget == false)
            const SizedBox.shrink()
          else
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 10),
                  padding: const EdgeInsets.all(10),
                  color: widget.addedRealEstate_Text == "2"
                      ? Colors.blue.shade600
                      : widget.addedRealEstate_Text == "4"
                          ? const Color(0xff6366f1)
                          : widget.addedRealEstate_Text == "true"
                              ? Colors.green
                              : widget.addedRealEstate_Text == "false"
                                  ? Colors.red.shade700
                                  : kPrimaryColor,
                  child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: robotoMedium)),
                )),
          Positioned(
              top: 15,
              right: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: IconButton(
                      onPressed: () {
                        addFavorite();
                      },
                      icon: Icon(
                        liked ? IconlyBold.heart : IconlyLight.heart,
                        color: liked ? kPrimaryColor : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                    onSelected: (int index) async {
                      if (index == 0) {
                        call(widget.phone);
                      } else if (index == 1) {
                        Share.share("$serverImage/${widget.images[selectedIndex]['destination']}-big.webp", subject: 'Gamyş programmasy');
                      }
                    },
                    itemBuilder: (context) {
                      return List.generate(buttonName.length, (index) {
                        return PopupMenuItem(
                          value: index,
                          child: Text(
                            buttonName[index],
                            style: const TextStyle(color: Colors.black, fontFamily: robotoRegular),
                          ),
                        );
                      });
                    },
                  ),
                ],
              )),

          if (widget.vip == true)
            Positioned(
                top: 15,
                left: 15,
                child: Container(
                  color: Colors.white,
                  width: 50,
                  height: 40,
                ))
          else
            const SizedBox.shrink(),

          if (widget.vip == true)
            Positioned(
                top: 10,
                left: 10,
                child: Image.asset(
                  "assets/icons/pngIcons/2.png",
                  height: 50,
                  color: const Color(0xffffac33),
                  fit: BoxFit.cover,
                  width: 60,
                ))
          else
            const SizedBox.shrink(),
          // widget.vip == true
          //     ? Positioned(
          //         bottom: 0,
          //         child: Container(
          //             width: Get.size.width,
          //             color: Color(0xffffac33),
          //             // color: Color(0xffffcb7f),
          //             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          //             height: 30,
          //             child: Text("VIP", style: TextStyle(color: Colors.white, fontFamily: robotoMedium))))
          //     : SizedBox.shrink(),
        ],
      ),
    ));
  }

  Widget miniImage(
    String image,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (widget.addedRealEstate_Widget == true) {
            updateReaLEstateController.myArray.clear();
            authController.signInAnimation.value = false;

            Get.to(() => UpdateReaLEstate(
                  id: widget.id,
                ));
          } else {
            Get.to(() => RealEstateProfil(
                  id: widget.id,
                  name: widget.name,
                  price: widget.price,
                ));
            if (historyView.isEmpty) {
              historyView.add(widget.id);
            } else {
              bool value = false;
              for (final element in historyView) {
                if (element == widget.id) {
                  value = true;
                }
              }
              if (value == false) historyView.add(widget.id);
            }
          }
        },
        child: CachedNetworkImage(
          colorBlendMode: BlendMode.difference,
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => Center(child: spinKit()),
          errorWidget: (context, url, error) => const Icon(Icons.error_outline),
        ),
      ),
    );
  }

  Container callButton() {
    return Container(
      width: Get.size.width,
      margin: const EdgeInsets.all(5),
      child: RaisedButton(
        onPressed: () {
          call(widget.phone);
        },
        color: backgroundColor,
        elevation: 0.0,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call, color: kPrimaryColor, size: 30),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "call".tr,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontFamily: robotoMedium,
                    fontSize: 18,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  GestureDetector namePart() {
    final String price = widget.price;
    final int a = int.parse(price);
    final oCcy = NumberFormat('###,000', 'fr');

    return GestureDetector(
      onTap: () {
        realEstatesController.changeIndex(0);
        if (widget.addedRealEstate_Widget == true) {
          authController.signInAnimation.value = false;
          updateReaLEstateController.myArray.clear();
          Get.to(() => UpdateReaLEstate(
                id: widget.id,
              ));
        } else {
          Get.to(() => RealEstateProfil(
                id: widget.id,
                name: widget.name,
                price: widget.price,
              ));
          if (historyView.isEmpty) {
            historyView.add(widget.id);
          } else {
            bool value = false;
            for (final element in historyView) {
              if (element == widget.id) {
                value = true;
              }
            }
            if (value == false) historyView.add(widget.id);
          }
        }
      },
      child: Container(
        width: Get.size.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: oCcy.format(a),
                          style: TextStyle(fontFamily: widget.vip == true ? robotoBold : robotoMedium, letterSpacing: 1.0, fontSize: 24, overflow: TextOverflow.ellipsis, color: Colors.black)),
                      TextSpan(text: "  TMT", style: TextStyle(fontFamily: widget.vip == true ? robotoBold : robotoMedium, fontSize: 16, overflow: TextOverflow.ellipsis, color: Colors.black))
                    ]),
                  ),
                ),
                if (widget.ownerId == 1)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: backgroundColor, borderRadius: borderRadius5),
                    child: Text("EYESINDEN", style: TextStyle(fontFamily: robotoMedium, fontSize: 12, color: Colors.grey[600])),
                  )
                else
                  const SizedBox.shrink()
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                widget.name,
                style: TextStyle(fontFamily: widget.vip == true ? robotoMedium : robotoMedium, fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                widget.location,
                style: const TextStyle(fontFamily: robotoRegular, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: RaisedButton(
        onPressed: () {},
        color: Colors.white,
        disabledColor: Colors.white,
        disabledElevation: 2,
        elevation: 2,
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imagePart(),
            namePart(),
            if (widget.phone == "") const SizedBox.shrink() else callButton(),
          ],
        ),
      ),
    );
  }
}
