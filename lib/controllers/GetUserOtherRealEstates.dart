// ignore_for_file: file_names, avoid_void_async, always_declare_return_types, type_annotate_public_apis, invariant_booleans, require_trailing_commas

import 'package:gamys/models/UserModels/UserRealEstatesModel.dart';
import 'package:get/state_manager.dart';

class GetUserOtherRealEstates extends GetxController {
  RxList list = [].obs;
  RxInt loading = 0.obs;
  RxInt page = 0.obs;
  RxInt pageNumberMine = 0.obs;
  RxInt userID = 0.obs;

  void fetchRealEstates(int _userID) async {
    userID.value = _userID;
    final products = await UserRealEstateModel().getUserRealEstates(parametrs: {
      "page": "${page.value}",
      "limit": '20',
      "user_id": "$_userID",
    }, id: _userID);
    if (products == null) {
      loading.value = 2;
    } else if (products == null) {
      loading.value = 3;
    } else if (products != null) {
      loading.value = 1;
      for (final element in products) {
        list.add({
          "id": element.id,
          "ownerID": element.ownerId,
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
    if ((pageNumberMine / 20) > page.value) {
      page.value += 1;
      fetchRealEstates(userID.value);
    } else {
      page.value += 1;
      fetchRealEstates(userID.value);
    }
  }

  refreshPage() {
    page.value = 0;
    list.clear();
    loading.value = 0;
    fetchRealEstates(userID.value);
  }
}
