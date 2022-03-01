// ignore_for_file: must_be_immutable, deprecated_member_use, file_names, depend_on_referenced_packages, type_annotate_public_apis, always_declare_return_types

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/GetUserOtherRealEstates.dart';
import 'package:gamys/controllers/ProfilPageController.dart';
import 'package:gamys/controllers/RealEstatesController.dart';
import 'package:gamys/models/GetLocation.dart';
import 'package:gamys/models/RealEstateProfileModel.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:gamys/models/UserModels/UserSignInModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "package:latlong2/latlong.dart" as latlong;
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PhotoView.dart';
import 'ShowOnMap.dart';
import 'getUserRealEstates.dart';

class RealEstateProfil extends StatelessWidget {
  final RealEstatesController realEstatesController = Get.put(RealEstatesController());
  final String name;
  final String price;
  final int id;
  RealEstateProfil({
    Key key,
    this.id,
    @required this.name,
    @required this.price,
  }) : super(key: key);
  addFavorite() async {
    bool favRealEstate = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMap = json.encode(myList);
    final token = await Auth().getToken();

    for (final element in myList) {
      if (element == id) {
        favRealEstate = true;
      }
    }

    if (favRealEstate == false) {
      myList.add(id);
      realEstatesController.favButton.value = true;
      token == null
          ? showSnackBar("addedFavoriteTitle", "addedFavoriteSubtitle", kPrimaryColor)
          : RealEstatesModel().addFavorite(id).then((value) {
              if (value == true) showSnackBar("addedFavoriteTitle", "addedFavoriteSubtitle", kPrimaryColor);
            });
    } else {
      removeFavorite();
    }
    prefs.setString('cart', encodedMap);
  }

  removeFavorite() async {
    final token = await Auth().getToken();
    myList.removeWhere((element) => element == id);

    if (token != null) {
      RealEstatesModel().removeFavorite(id).then((value) {
        if (value == true) {
          showSnackBar("removeFavoriteTitle", "removeFavoriteSubtitle", kPrimaryColor);
          realEstatesController.favButton.value = false;
        } else {
          showSnackBar("retry", "error404", kPrimaryColor);
        }
      });
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedMap = json.encode(myList);
      realEstatesController.favButton.value = false;
      showSnackBar("removeFavoriteTitle", "removeFavoriteSubtitle", kPrimaryColor);
      prefs.setString('cart', encodedMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: kPrimaryColor),
              onPressed: () {
                if (realEstatesController.imageUrl.value == "") {
                  showSnackBar("noImage".tr, "error".tr, kPrimaryColor);
                } else {
                  Share.share(realEstatesController.imageUrl.value, subject: 'Gamyş programmasy');
                }
              },
            ),
            IconButton(
              icon: Obx(() {
                return Icon(
                  realEstatesController.favButton.value ? IconlyBold.heart : IconlyLight.heart,
                  color: realEstatesController.favButton.value ? Colors.red : kPrimaryColor,
                );
              }),
              onPressed: () {
                addFavorite();
              },
            ),
            const SizedBox(
              width: 10,
            )
          ],
          titleSpacing: 0.0,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(text: price ?? "0", style: const TextStyle(fontFamily: robotoMedium, fontSize: 26, color: Colors.black)),
                        const TextSpan(text: "  TMT", style: TextStyle(fontFamily: robotoMedium, fontSize: 16, color: Colors.black))
                      ]),
                    ),
                    Text(name ?? "Gamys", overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: robotoMedium)),
                  ],
                ),
              ),
            ],
          )),
      body: FutureBuilder<RealEstateProfileModel>(
          future: RealEstateProfileModel().getRealEstatesById(id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: ConnectionError(
                    buttonText: "",
                    onTap: () {
                      Get.back();
                    }),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: spinKit());
            } else if (snapshot.data == null) {
              return Center(
                child: EmptyPage(
                  image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                  text: "error",
                  subtitle: "",
                  buttonText: "",
                  onTap: () {},
                ),
              );
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imagePart(snapshot),
                      nameCard(
                        snapshot.data,
                      ),
                      userDetail(snapshot.data),
                      mapCard(snapshot.data.position[0]["lat"], snapshot.data.position[0]["lng"], snapshot.data.name),
                      description(snapshot.data),
                      sameRealEstates(
                        snapshot.data,
                      ),
                      const SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
                Align(alignment: Alignment.bottomCenter, child: bottomNavBar(snapshot.data))
              ],
            );
          }),
      // bottomSheet: bottomNavBar(),
    );
  }

  Card nameCard(
    RealEstateProfileModel product,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
      child: Container(
        width: Get.size.width,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(text: product.price, style: const TextStyle(fontFamily: robotoMedium, fontSize: 26, color: Colors.black)),
                const TextSpan(text: "  TMT", style: TextStyle(fontFamily: robotoMedium, fontSize: 16, color: Colors.black))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                product.name,
                maxLines: 2,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      IconlyLight.location,
                      size: 25,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10, right: 15),
                      child: Text(product.location, style: TextStyle(color: Colors.grey[400], fontSize: 16, fontFamily: robotoRegular)),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      IconlyLight.calendar,
                      size: 25,
                      color: Colors.grey[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10, right: 15),
                      child: Text(product.createdAt.substring(0, 10), style: TextStyle(color: Colors.grey[400], fontSize: 16, fontFamily: robotoRegular)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container imagePart(AsyncSnapshot<RealEstateProfileModel> snapshot) {
    return Container(
      color: backgroundColor,
      height: Get.size.height / 2.2,
      child: snapshot.data.images.length == 1
          ? noImage()
          : CarouselSlider.builder(
              itemCount: snapshot.data.images.length as int,
              options: CarouselOptions(
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    realEstatesController.changeIndex(index + 1);
                  },
                  viewportFraction: 0.90,
                  enableInfiniteScroll: false,
                  height: Get.size.height),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                if (snapshot.data.images.length > 1 != null) {
                  realEstatesController.imageUrl.value = "$serverImage/${snapshot.data.images[index]['destination']}-large.webp";
                } else {
                  realEstatesController.imageUrl.value = "";
                }
                return GestureDetector(
                    onTap: () {
                      Get.to(() => Photoview(images: snapshot.data.images));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                        right: 5,
                        bottom: 5,
                      ),
                      decoration: const BoxDecoration(borderRadius: borderRadius10),
                      child: CachedNetworkImage(
                        colorBlendMode: BlendMode.difference,
                        imageUrl: "$serverImage/${snapshot.data.images[index]['destination']}-mini.webp",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: borderRadius10,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(child: spinKit()),
                        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                      ),
                    ));
              },
            ),
    );
  }

  final GetUserOtherRealEstates userRealEstates = Get.put(GetUserOtherRealEstates());

  Card userDetail(RealEstateProfileModel product) {
    int a = int.parse(product.userRealEstateCount);
    userRealEstates.pageNumberMine.value = a;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.grey[300].withOpacity(0.4), shape: BoxShape.circle),
                  child: Text(
                    product.fullName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 24),
                  )),
              Text(
                product.fullName,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
              )
            ],
          ),
          dividerr(),
          ListTile(
            onTap: () {
              call(product.phoneNumber);
            },
            title: Text(
              "+993${product.phoneNumber}",
              style: const TextStyle(color: Colors.black, fontFamily: robotoRegular),
            ),
            leading: const Icon(Icons.call),
          ),
          dividerr(),
          ListTile(
            onTap: () {
              final int abc = int.parse(product.userID);
              Get.to(() => GetAllRealEstates(
                    id: abc,
                  ));
            },
            title: Get.locale.languageCode == "ru"
                ? Text(
                    "${"userRealEstateCountTitle".tr} ${product.fullName} ${product.userRealEstateCount}",
                    style: const TextStyle(color: Colors.black, fontFamily: robotoRegular),
                  )
                : Text(
                    "${product.fullName} ${"userRealEstateCountTitle".tr} ${product.userRealEstateCount}",
                    style: const TextStyle(color: Colors.black, fontFamily: robotoRegular),
                  ),
            leading: const Icon(IconlyLight.document),
            trailing: const Icon(IconlyLight.arrowRightCircle),
          ),
        ],
      ),
    );
  }

  Card mapCard(double lat, double long, String name) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text("showMap".tr, style: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 17)),
          ),
          Container(
            height: 200,
            color: Colors.black,
            child: FlutterMap(
              options: MapOptions(center: latlong.LatLng(lat, long), maxZoom: 18.0, minZoom: 3.0),
              layers: [
                TileLayerOptions(backgroundColor: Colors.white, urlTemplate: "$serverMapImage/tile/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 25.0,
                      height: 25.0,
                      point: latlong.LatLng(lat, long),
                      builder: (ctx) => Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue), child: const Icon(IconlyBold.home, size: 16, color: Colors.white))),
                ]),
              ],
            ),
          ),
          dividerr(),
          Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: RaisedButton(
              color: Colors.white,
              disabledColor: Colors.white,
              elevation: 0,
              onPressed: () {
                Get.to(() => ShowOnMap(lat: lat, long: long, name: name));
              },
              child: Text("showMap".tr, style: const TextStyle(color: kPrimaryColor, fontFamily: robotoBold, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Padding bottomNavBar(RealEstateProfileModel product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: RaisedButton(
        onPressed: () async {
          call(product.phoneNumber);
        },
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadius5,
        ),
        color: kPrimaryColor, //Colors.green,
        elevation: 5,
        disabledColor: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.call, color: Colors.white, size: 30),
            ),
            Text(
              "call".tr,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, //kPrimaryColor,
                  fontFamily: robotoMedium,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  call(String phoneNumber) async {
    print("asd");
    var status = await Permission.phone.status;
    if (status == PermissionStatus.denied) {
      await Permission.phone.request();
    }
    await Permission.phone.request().isGranted; //ca.request().isGranted
    print(status);
    // bool res = await FlutterPhoneDirectCaller.callNumber("+993${phoneNumber}");
    // await FlutterPhoneDirectCaller.callNumber("+993$phoneNumber");
  }

  final ProfilePageController profilePageController = Get.put(ProfilePageController());

  Column sameRealEstates(RealEstateProfileModel realEstates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 10, bottom: 15),
          child: Text(
            "sameRealEstates".tr,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: robotoMedium, fontSize: 20, color: kPrimaryColor),
          ),
        ),
        FutureBuilder<List<RealEstatesModel>>(
            future: RealEstatesModel()
                .getRealEstates(parametrs: {"type_id": "${realEstates.typeID}", "category_id": "${realEstates.categoryID}", "page": "${0}", "limit": "${5}", "user_id": authController.userId.value}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: spinKit());
              } else if (snapshot.hasError) {
                return Center(child: Text("error404".tr, style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16)));
              } else if (snapshot.data == null) {
                return Center(child: Text("error".tr, style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16)));
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final int a = int.parse(snapshot.data[index].price);
                  final oCcy = NumberFormat('###,000', 'fr');
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => RealEstateProfil(id: snapshot.data[index].id, name: snapshot.data[index].name, price: snapshot.data[index].price)));

                      if (historyView.isEmpty) {
                        historyView.add(snapshot.data[index].id);
                      } else {
                        bool value = false;
                        for (final element in historyView) {
                          if (element == snapshot.data[index].id) {
                            value = true;
                          }
                        }
                        if (value == false) historyView.add(snapshot.data[index].id);
                      }
                    },
                    child: Container(
                      width: Get.size.width,
                      color: Colors.white,
                      height: 130,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: snapshot.data[index].images.length > 1 != null
                                  ? Center(
                                      child: CachedNetworkImage(
                                        colorBlendMode: BlendMode.difference,
                                        imageUrl: "$serverImage/${snapshot.data[index].images[1]['destination']}-mini.webp",
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(child: spinKit()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/svgIcons/logo.svg",
                                              color: Colors.grey[500],
                                              width: 60,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "noImage".tr,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontFamily: robotoMedium),
                                          )
                                        ],
                                      ),
                                    )),
                          Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(text: oCcy.format(a), style: const TextStyle(fontFamily: robotoMedium, fontSize: 25, color: Colors.black)),
                                        const TextSpan(text: "  TMT", style: TextStyle(fontFamily: robotoMedium, fontSize: 16, color: Colors.black))
                                      ]),
                                    ),
                                    Text(snapshot.data[index].name, style: const TextStyle(fontFamily: robotoRegular, fontSize: 18, color: Colors.black)),
                                    SizedBox(
                                        width: Get.size.width,
                                        child:
                                            Text(snapshot.data[index].location, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: robotoLight, fontSize: 16, color: Colors.black))),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ],
    );
  }

  TextEditingController controller = TextEditingController();
  Column description(RealEstateProfileModel product) {
    Padding specText(
      RealEstateProfileModel product,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              product.specifications.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${product.specifications[index].name} :",
                        style: const TextStyle(color: Colors.grey, fontFamily: robotoRegular, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        product.specifications[index].values[0].name ?? product.specifications[index].values[0].absoluteValue,
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: Colors.black, fontFamily: robotoRegular, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 10, bottom: 15),
          child: Text(
            "aboutRealEstateID".tr,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: robotoMedium, fontSize: 20, color: kPrimaryColor),
          ),
        ),
        Card(
          elevation: 2,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                specText(
                  product,
                ),
                dividerr(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    "description".tr,
                    style: const TextStyle(fontFamily: robotoMedium, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(product.description, style: const TextStyle(color: Colors.black, fontFamily: robotoRegular, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
          width: Get.size.width,
          child: RaisedButton(
              onPressed: () async {
                controller.clear();
                final token = await Auth().getToken();
                token == null
                    ? showSnackBar("loginError".tr, "loginSubtitle".tr, kPrimaryColor)
                    : Get.defaultDialog(
                        title: "alert".tr,
                        titlePadding: const EdgeInsets.symmetric(vertical: 20),
                        radius: 5,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: controller,
                                maxLength: 140,
                                cursorColor: kPrimaryColor,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontFamily: robotoRegular),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: borderRadius5,
                                  ),
                                  focusedBorder: OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: kPrimaryColor)),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: Get.size.width,
                                child: RaisedButton(
                                  onPressed: () {
                                    GetLocationModel().makeComplaint(realEstateID: id, body: {"message": controller.text}).then((value) {
                                      if (value == true) {
                                        Get.back();

                                        showSnackBar("sendedTitle", "sendedSubtitle", kPrimaryColor);
                                      } else {
                                        Get.back();

                                        showSnackBar("errorSnapshot", "error", kPrimaryColor);
                                      }
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  color: kPrimaryColor,
                                  elevation: 0.0,
                                  focusElevation: 0.0,
                                  disabledElevation: 0.0,
                                  shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                                  child: Text("send".tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: robotoMedium)),
                                ),
                              )
                            ],
                          ),
                        ));
              },
              elevation: 2.0,
              color: Colors.white,
              disabledElevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text("alert".tr,
                  style: const TextStyle(
                    fontFamily: robotoMedium,
                    color: Colors.red,
                    fontSize: 18,
                  ))),
        )
      ],
    );
  }
}
