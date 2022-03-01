// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, avoid_void_async

import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/UserModels/UserRealEstatesModel.dart';
import 'package:get/get.dart';

class UpdateReaLEstateController extends GetxController {
  RxList updateValues = [].obs;
  RxList myArray = [].obs;
  RxInt loading = 0.obs;
  RxList list = [].obs;
  final AuthController authController = Get.put(AuthController());
  final page = 0.obs;

  @override
  onInit() {
    super.onInit();
    fetchRealEstates();
  }

  void fetchRealEstates() async {
    final products = await UserRealEstateModel().getUserAddedRealEstates(parametrs: {"page": "${page.value}", "limit": '20', "user_id": authController.userId.value});
    if (products == null) {
      loading.value = 1;
    } else if (products != null) {
      loading.value = 2;
      for (final element in products) {
        list.add({
          "id": element.id,
          "images": element.images,
          "location": element.location,
          "name": element.name,
          "isActive": element.isActive,
          "statusID": element.statusId,
          "wishList": element.wishList,
          "price": element.price,
        });
      }
    }
  }

  addPage() {
    if ((pageNumber / 20) > page.value + 1) {
      page.value += 1;
      fetchRealEstates();
    }
  }

  refreshPage() {
    page.value = 0;

    list.clear();
    loading.value = 0;
    fetchRealEstates();
  }
}
