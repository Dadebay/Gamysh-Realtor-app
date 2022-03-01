// ignore_for_file: avoid_positional_boolean_parameters, implementation_imports, prefer_const_constructors, deprecated_member_use, avoid_void_async, require_trailing_commas, duplicate_ignore

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:get/get.dart';

class ConnectionCheck extends StatefulWidget {
  @override
  _ConnectionCheckState createState() => _ConnectionCheckState();
}

class _ConnectionCheckState extends State<ConnectionCheck> {
  bool firsttime = false;

  @override
  void initState() {
    super.initState();
    setData();
    checkConnection();
  }

  void setData() {
    setState(() {
      loadDataFirstTime().then((value) {
        firsttime = value ?? false;
      });
    });
  }

  Future langSelect() => showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: borderRadius10),
              title: Text(
                "Dil saýlaň",
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ignore: require_trailing_commas
                  ListTile(
                      onTap: () {
                        Get.to(() => BottomNavBar());
                        Get.updateLocale(Locale("en"));
                        firsttimeSaveData(true);
                        saveData("en");
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          turkmenIcon,
                        ),
                        radius: 20,
                      ),
                      title: Text('Türkmen',
                          textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.black, fontFamily: robotoRegular, fontSize: 18))),
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                      onTap: () {
                        Get.to(() => BottomNavBar());
                        Get.updateLocale(Locale("ru"));
                        firsttimeSaveData(true);
                        saveData("ru");
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          russianIcon,
                        ),
                        radius: 20,
                      ),
                      title: Text('Русский',
                          textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.black, fontFamily: robotoRegular, fontSize: 18))),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 500),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return null;
      });

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (firsttime == false) {
          langSelect();
        } else {
          Future.delayed(Duration(milliseconds: 2000), () {
            Get.to(() => BottomNavBar());
          });
        }
      }
    } on SocketException catch (_) {
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: borderRadius20),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      padding: EdgeInsets.only(top: 100),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'noConnection1'.tr,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: kPrimaryColor,
                              fontFamily: robotoMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Text(
                              'noConnection2'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: robotoMedium,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(borderRadius: borderRadius10),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Future.delayed(Duration(milliseconds: 1000), () {
                                checkConnection();
                              });
                            },
                            child: Text(
                              "noConnection3".tr,
                              style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: robotoMedium),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 70,
                      minRadius: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          child: Image.asset(
                            "assets/icons/gifIcons/noconnection.gif",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
            stops: const [0.0, 0.4],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: const [Colors.white, kPrimaryColor],
          )))),
          Positioned.fill(child: Center(child: Image.asset("assets/images/Gamys-02.png", height: 250, width: 250, fit: BoxFit.cover))),
        ],
      ),
    );
  }
}
