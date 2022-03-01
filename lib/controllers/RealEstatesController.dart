// ignore_for_file: file_names, avoid_void_async, always_declare_return_types, type_annotate_public_apis, invariant_booleans, require_trailing_commas

import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/RealEstatesModel.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';

class RealEstatesController extends GetxController {
  RxList list = [].obs;
  RxInt loading = 0.obs;
  final page = 0.obs;
  RxString phoneNumber = "65555555".obs;
  RxString imageUrl = "".obs;
  RxInt selectedImageIndex = 1.obs;
  final realEstateName = "Gamyş".obs;
  final realEstatePrice = "0".obs;
  RxBool favButton = false.obs;

  @override
  onInit() {
    super.onInit();
    fetchRealEstates();
  }

  changePrice(String index) {
    realEstatePrice.value = index;
  }

  changeName(String index) {
    realEstateName.value = index;
  }

  changeIndex(int index) {
    selectedImageIndex.value = index;
  }

  changePhoneNumber(String phone) {
    phoneNumber.value = phone;
  }

  final AuthController authController = Get.put(AuthController());

  void fetchRealEstates() async {
    final products = await RealEstatesModel().getRealEstates(parametrs: {"page": "${page.value}", "limit": '20', "user_id": authController.userId.value});
    if (products == null) {
      loading.value = 2;
    } else if (products == null) {
      loading.value = 3;
    } else if (products != null) {
      loading.value = 1;
      for (final element in products) {
        list.add({
          "id": element.id,
          "vip": element.vipTypeId,
          "name": element.name,
          "wishList": element.wishList,
          "price": element.price,
          "location": element.location,
          "images": element.images,
          "phone": element.phoneNumber
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
