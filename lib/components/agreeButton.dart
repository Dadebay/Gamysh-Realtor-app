// ignore_for_file: avoid_redundant_argument_values, file_names

import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:get/get.dart';

class AgreeButton extends StatelessWidget {
  // final bool animation;

  AgreeButton({
    Key key,
    this.name,
    this.onTap,
    this.color,
    this.textColor,
  }) : super(key: key);

  final Function() onTap;
  final AuthController authController = Get.put(AuthController());
  final Color color;
  final String name;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: onTap,
        child: Center(
          child: PhysicalModel(
            elevation: 4,
            borderRadius: borderRadius10,
            color: color,
            shadowColor: Colors.black,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: borderRadius10,
                color: color,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              curve: Curves.ease,
              width: authController.signInAnimation.value ? 70 : Get.size.width,
              duration: const Duration(milliseconds: 1000),
              child: authController.signInAnimation.value
                  ? Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: textColor,
                        ),
                      ),
                    )
                  : Text(
                      name.tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontFamily: robotoMedium, color: textColor),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
