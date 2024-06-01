import 'package:food_truck/model/foodtruck_model.dart';

import 'app_id.dart';
import '../view/home_view.dart';
//import 'package:food_truck/view/search_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_pages.dart';

class FoodtruckupdatemapController extends GetxController {
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  var foodtruckid = ''.obs;

  void setFoodTruckId(String id) {
    foodtruckid.value = id;
  }

  void goUpdate(foodtruckid, latitude, longitude) {
    Get.toNamed(
      Routes.FOODTRUCKUPDATE,
      arguments: {
        'foodtruck_id': foodtruckid,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }

  getFoodTruckData() async {
    return _foodTruckModel.getFoodTruckData();
  }
}
