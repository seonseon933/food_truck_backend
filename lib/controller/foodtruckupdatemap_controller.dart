import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/app_pages.dart';
import 'package:get/get.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';

class FoodtruckupdatemapController extends GetxController {
  double jlatitude = 35.139988984673806;
  double jlongitude = 126.93423855903913;
  RxString juso = "버튼을 눌러 도로명 주소를 검색해주세요".obs;
  late Map<String, dynamic> foodtruck;

  String foodtruckid = "";
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  File? file;

  gotoupdate() {
    //foodtruck["truck_id"] = foodtruckid;
    foodtruck["truck_latitude"] = jlatitude;
    foodtruck["truck_longitude"] = jlongitude;
    Get.offNamed(Routes.FOODTRUCKUPDATE, arguments: foodtruck);
  }

  Future<Map<String, dynamic>> getDetailFoodTruck(String foodtruckid) async {
    foodtruck = await _foodTruckModel.getDetailFoodTruck(foodtruckid);
    return foodtruck;
  }
}
