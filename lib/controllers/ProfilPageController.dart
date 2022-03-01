// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis

import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  RxString token = "".obs;
  RxInt countRealEstates = 0.obs;
  RxInt loading = 0.obs;
  final page = 0.obs;

  changeCustomToken(String token1) async {
    token.value = token1;
  }

  changeRealEstateCount(int a) async {
    countRealEstates.value = a;
  }
  // addPage() {
  //   if ((pageNumber / 20) > page.value + 1) {
  //     page.value += 1;
  //     fetchRealEstates();
  //   }
  // }

  // refreshPage() {
  //   page.value = 0;
  //   list.clear();
  //   loading.value = 0;
  //   fetchRealEstates();
  // }
}
