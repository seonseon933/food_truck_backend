import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';
import 'app_pages.dart';

class FoodtruckupdateController extends GetxController {
  final _picker = ImagePicker();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FoodtruckController foodtruckController =
      Get.find<FoodtruckController>();

  void goDetail(foodtruck) {
    while (Get.previousRoute == Routes.FOODTRUCKUPDATEMAP) {
      Get.back();
    }
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  Future<void> updateFoodTruck(
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
    await _foodTruckModel.updateFoodTruck(
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
    await foodtruckController.ObsgetFoodTruckData(); // 목록페이지 데이터 갱신
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
    return _foodTruckModel.getDetailFoodTruck(foodtruckid);
  }
}
