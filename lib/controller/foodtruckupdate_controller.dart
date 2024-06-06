import 'package:flutter/material.dart';
import 'package:food_truck/controller/app_id.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';
import 'app_pages.dart';

class FoodtruckupdateController extends GetxController {
  double jlatitude = 35.139988984673806;
  double jlongitude = 126.93423855903913;
  RxString juso = "버튼을 눌러 도로명 주소를 검색해주세요".obs;
  late final foodtruck;
  String foodtruckid = "";
  final _picker = ImagePicker();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  File? file;
  NetworkImage? fileimg;

  void goDetail() {
    Get.back();
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.back();
    });
  }

  goupdateview() {
    Get.toNamed(Routes.FOODTRUCKUPDATE);
  }

  Future<String> updateFoodTruck(
      String foodtruckid,
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File? file,
      String truckTag,
      double latitude,
      double longitude) async {
    return _foodTruckModel.updateFoodTruck(
        foodtruckid,
        truckName,
        truckDescription,
        truckSchedule,
        truckPhone,
        paymentOptions,
        file,
        truckTag,
        latitude,
        longitude);
  }

  // 이미지를 갤러리에서 가져올 수 있도록.
  Future<File?> getFoodTruckImgGaller() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }

  // 해당 푸드트럭 데이터 가져오기 (모델getDetailFoodTruck 코드 변경됨)
  Future<Map<String, dynamic>> getDetailFoodTruck(String foodtruckid) async {
    foodtruck = await _foodTruckModel.getDetailFoodTruck(foodtruckid);
    fileimg = NetworkImage(foodtruck["truck_img"]);
    return foodtruck;
  }
}
