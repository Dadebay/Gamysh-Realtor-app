// ignore_for_file: file_names, type_annotate_public_apis, always_declare_return_types, avoid_positional_boolean_parameters, invariant_booleans

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamys/models/FilterModel.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  RxInt changeMainLocationIndex = 0.obs;
  RxList choiceChipList = [].obs;
  RxList list = [].obs;
  RxInt loading = 0.obs;
  RxInt locationId = 1.obs;
  RxInt mainTypeIndex = 0.obs;
  final page = 0.obs;
  RxDouble realEstateCount = 0.0.obs;
  RxInt realtorID = 1.obs;
  RxList<dynamic> specListMine = [].obs;
  RxBool specValue = false.obs;
  RxInt subTypeIndex = 0.obs;
  RxInt tabbarIndex = 0.obs;
  RxInt typeId = 3.obs;
  RxList typeIdList = [].obs;
  RxList typeIdList2 = [].obs;
  RxList<dynamic> typeIdListaArray = [].obs;
  RxBool showAllFilters = false.obs;

  ///Sort elements\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  RxString sortName = "sortDefault".obs;
  RxString sortColumn = "".obs;
  RxString sortDirection = "".obs;

  ///Sort elements\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  fetchRealEstates(int categoryID, List typeID, int realtorID, String price, String area, int locationID, String userID, var specValueMine, int mainTypeId) async {
    final products = await FilterModel().getFilteredRealEstates(parametrs: {
      "category_id": "$categoryID",
      "type_id": json.encode(typeID),
      "main_type_id": "$mainTypeId",
      "owner_id": "$realtorID",
      "price": price,
      "area": area,
      "location_id": "$locationID",
      "spec_values": json.encode(specValueMine),
      "page": "${page.value}",
      "limit": '20',
      "user_id": userID,
      "sort_column": sortColumn.value,
      "sort_direction": sortDirection.value,
    });
    if (products == null) {
      loading.value = 2;
    } else if (products == null) {
      loading.value = 3;
    } else if (products != null) {
      loading.value = 1;
      for (final element in products) {
        list.add({
          "id": element.id,
          "name": element.name,
          "price": element.price,
          "owner_id": element.ownerId,
          "vip": element.vipTypeId,
          "location": element.location,
          "phone": element.phoneNumber,
          "images": element.images,
          "wishList": element.wishList,
        });
      }
    }
  }

/////Filtered Page Page and Limit

  addChoiceChipList(AsyncSnapshot snapshot, int indexx) {
    choiceChipList.add({"id": snapshot.data[indexx].specId, "list": []});
    snapshot.data[indexx].values.forEach((element) {
      choiceChipList[indexx]["list"].add({"id": element["value_id"], "value": false});
    });
  }

  addSpecList(int id, List values) {
    specListMine.add({"id": id, "values": values});
  }

  addTypeIdList(int id, bool value) {
    typeIdList.add({"id": id, "value": value});
  }

  addTypeIdList2(int id, bool value) {
    typeIdList2.add({"id": id, "value": value});
  }

  updateTypeIdList2(int id) {
    for (final element in typeIdList2) {
      if (element["id"] == id) {
        if (element["value"] == false) {
          element["value"] = true;
        } else {
          element["value"] = false;
        }
      }
    }
    typeIdList2.refresh();
  }

  updateTypeIdList(int id) {
    for (final element in typeIdList) {
      if (element["id"] == id) {
        if (element["value"] == false) {
          element["value"] = true;
        } else {
          element["value"] = false;
        }
      }
    }
    typeIdList.refresh();
  }

  removeSpecList(int id, List values) {
    specListMine.add({"id": id, "values": values});
  }

  searchAndAddSpecList({int specID, int id, List values}) {
    specValue.value = false;
    for (final element in specListMine) {
      if (element["id"] == specID) {
        element["values"] = values;
        specValue.value = true;
      }
    }

    if (specValue.value == false) {
      addSpecList(id, values);
    }
  }

  removeElement(int elementMine) {
    typeIdListaArray.remove(elementMine);
  }

  removeSpecListItem(int item, int id) {
    specListMine.forEach((element) {
      if (element["id"] == id) {
        List list = [];
        list = element["values"];
        element["values"] = [];
        list.forEach((element2) {
          if (element2 != item) {
            element["values"].add(element2);
          }
        });
      }
    });

    typeIdListaArray.remove(item);
  }

  changegetLocationID(int index) => locationId.value = index;

  changeTypeID(int index) => typeId.value = index;

  changeMainLocationINDEX(int index) => changeMainLocationIndex.value = index;

  changeSubTypeINDEX(int index) => subTypeIndex.value = index;

  changeMainINDEX(int index) => mainTypeIndex.value = index;
}
