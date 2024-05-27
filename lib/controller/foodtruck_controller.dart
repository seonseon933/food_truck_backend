import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';

class FoodTruckController {
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  // 상세 푸드트럭
  Future<Map<String, dynamic>> getDetailFoodTruck(String foodtruckid) async {
    return _foodTruckModel.getDetailFoodTruck(foodtruckid);
  }

  // 등록된 푸드트럭 데이터 가져오기
  Future<List<Map<String, dynamic>>> getFoodTruckData() async {
    return _foodTruckModel.getFoodTruckData();
  }

  // 태그와 일치하는 푸드트럭 목록
  Future<List<Map<String, String>>> searchFoodTrucksByTag(String tag) async {
    return _foodTruckModel.searchFoodTrucksByTag(tag);
  }

  // 찜한 푸드트럭 불러오기
  Future<List<String>> getFavoriteFoodTruck() async {
    User user = _auth.currentUser!;
    return _foodTruckModel.getFavoriteFoodTruck(user.uid);
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

  // 푸드트럭 생성 메소드 호출
  Future<String> createFoodTruck(
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File file,
      String truckTag) async {
    User user = _auth.currentUser!;
    return _foodTruckModel.createFoodTruck(truckName, truckDescription,
        truckSchedule, truckPhone, paymentOptions, file, truckTag, user.uid);
  }

  // 푸드트럭 수정 메소드 호출
  Future<String> updateFoodTruck(
      String foodtruckid,
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      String truckTag,
      File? file) async {
    User user = _auth.currentUser!;
    return _foodTruckModel.updateFoodTruck(
        foodtruckid,
        truckName,
        truckDescription,
        truckSchedule,
        truckPhone,
        paymentOptions,
        file,
        truckTag,
        user.uid);
  }

  Future<void> deleteFoodTruck(String foodtruckid) async {
    _foodTruckModel.deleteFoodTruck(foodtruckid);
  }
}
