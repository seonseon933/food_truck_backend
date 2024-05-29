import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';
import 'app_id.dart';
import 'app_pages.dart';

class FoodtrucksettingController extends GetxController {
  final _picker = ImagePicker();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // void goBack() {
  //   Get.back(id: foodtruckD); // 눌러도 작동 안 함
  // }
  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

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
