import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'app_id.dart';

class FoodtruckcreateController extends GetxController {
  double jlatitude = 0.0;
  double jlongitude = 0.0;
  RxString juso = "버튼을 눌러 도로명 주소를 검색해주세요".obs;
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  late final File imgfile;
  void goBack() {
    Get.back(id: profileD);
  }

  getFoodTruckImgGaller() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      imgfile = file;
    }
    return null;
  }

  createFoodTruck(
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File file,
      String truckTag,
      double trucklatitude,
      double trucklongitude) {
    User user = _auth.currentUser!;
    return _foodTruckModel.createFoodTruck(
        truckName,
        truckDescription,
        truckSchedule,
        truckPhone,
        paymentOptions,
        imgfile,
        truckTag,
        user.uid,
        trucklatitude,
        trucklongitude);
  }
}
