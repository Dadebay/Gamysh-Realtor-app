// ignore_for_file: file_names, avoid_positional_boolean_parameters, always_declare_return_types, type_annotate_public_apis

import 'package:get/get.dart';

class AddRealEstateController extends GetxController {
  RxInt addedRealEstateId = 0.obs;
  RxList myArray = [].obs;
  RxBool textFieldShadowBool = false.obs;

  RxDouble currentZoom = 13.0.obs;
  RxInt id = 0.obs;

  changeAddedRealEstateId(int index) => addedRealEstateId.value = index;
}
