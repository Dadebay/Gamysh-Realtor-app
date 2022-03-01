// ignore_for_file: type_annotate_public_apis, always_declare_return_types, file_names

import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';

class AuthController extends GetxController {
  RxBool realtor = false.obs;
  RxBool signInAnimation = true.obs;
  RxBool signInObscure = true.obs;
  RxString userId = "".obs;
  String name = "notificationName".tr;
  @override
  void onInit() {
    signInObscure.value = true;
    signInAnimation.value = false;
    super.onInit();
  }

  changeRealtor() {
    if (realtor.isTrue) {
      realtor.toggle();
    } else {
      realtor.value = true;
    }
  }

  changeSignInObscure() {
    if (signInObscure.isTrue) {
      signInObscure.toggle();
    } else {
      signInObscure.value = true;
    }
  }

  changeSignInAnimation() {
    if (signInAnimation.isTrue) {
      signInAnimation.toggle();
    } else {
      signInAnimation.value = true;
    }
  }
}
