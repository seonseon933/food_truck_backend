import 'package:food_truck/controller/app_pages.dart';
import 'package:get/get.dart';
import 'dart:io';

class FoodtruckcreatemapController extends GetxController {
  File? file;
  RxString juso = "주소를 검색해주세요".obs;
  double jlatitude = 35.139988984673806;
  double jlongitude = 126.93423855903913;

  void gocreateview() {
    Get.offNamed(Routes.FOODTRUCKCREATE, arguments: {
      "truck_latitude": jlatitude,
      "truck_longitude": jlongitude
    });
  }
}
