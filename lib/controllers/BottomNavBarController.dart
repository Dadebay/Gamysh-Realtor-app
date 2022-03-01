// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types, use_setters_to_change_properties, avoid_positional_boolean_parameters

import 'package:gamys/models/GetLocation.dart';
import 'package:get/state_manager.dart';

class BottomNavBarController extends GetxController {
  RxInt categoryId = 1.obs;
  RxInt mainId = 0.obs;
  RxInt selectedPageBottomIndex = 0.obs;
  RxString token = "".obs;
  RxInt typeID = 0.obs;
  RxString locationName = "Aşgabat".obs;
  RxString example = "Aşgabat".obs;
  RxDouble currentUserLat2 = 37.922252.obs;
  RxDouble currentUserLong2 = 58.376016.obs;
  RxList textString = [].obs;

  RxInt mainLocationBig = 0.obs;
  RxInt mainLocationMini = 0.obs;
  RxList specList = [].obs;
  RxBool specValue = false.obs;
  @override
  void onInit() {
    super.onInit();
    GetLocationModel().getNames().then((value) {
      for (final element in value) {
        if (element.id == 1) {
          locationName.value = element.locationName;
        }
      }
    });
  }

  RxInt selectedPageIndex = 0.obs;
  dicrementPageIndex() {
    selectedPageIndex.value--;
  }

  incrementPageIndex() {
    selectedPageIndex.value++;
  }

  void changeName(String name) {
    locationName.value = name;
  }

  addSpecList(int id, bool isRequired, bool isMultiple, List values) {
    specList.add({"id": id, "is_required": isRequired, "is_multiple": isMultiple, "values": values});
  }

  searchAndAddSpecList({int specID, int id, bool isRequired, bool isMultiple, List values}) {
    specValue.value = false;
    for (final element in specList) {
      if (element["id"] == specID) {
        element["values"] = values;
        specValue.value = true;
      }
    }
    if (specValue.value == false) {
      addSpecList(id, isRequired, isMultiple, values);
    }
  }

  changeToken(String tokenOut) => token.value = tokenOut;

  selectedIndex(int index) => selectedPageBottomIndex.value = index;

  selectedTypeID(int index) => typeID.value = index;

  selectedCategoryId(int index) => categoryId.value = index;

  selectedMainId(int index) => mainId.value = index;
}
