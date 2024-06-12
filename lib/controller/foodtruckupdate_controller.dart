import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/app_pages.dart';
import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/controller/foodtruckdetail_controller.dart';
//import 'package:food_truck/controller/myfoodtruck_controller.dart';
import 'package:get/get.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';

class FoodtruckupdateController extends GetxController {
  final FoodtruckController foodtruckController =
      Get.find<FoodtruckController>();

  final nameController = TextEditingController().obs;
  final scheduleController = TextEditingController().obs;
  final bankController = TextEditingController().obs;
  final tagController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final accountHolderController = TextEditingController().obs;
  final accountNumberController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;

  final RxBool cash = false.obs;
  final RxBool card = false.obs;
  final RxBool bankTransfer = false.obs;

  late double jlatitude;
  late double jlongitude;
  RxString juso = "버튼을 눌러 도로명 주소를 검색해주세요".obs;
  late Map<String, dynamic> foodtruck;
  String foodtruckid = "";
  final _picker = ImagePicker();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  File? file;
  @override
  void onInit() {
    super.onInit();
    foodtruck = Get.arguments;
    print('foodtruck : $foodtruck');
    getText();
  }

  goDetail() {
    if (Get.isRegistered<FoodtruckdetailController>()) {
      final dcontroller = Get.find<FoodtruckdetailController>();
      dcontroller.foodtruck["truck_name"] = nameController.value.text;
    }
    if (Get.isRegistered<FoodtruckController>()) {
      final fcontroller = Get.find<FoodtruckController>();
      fcontroller.update();
    } /* else if (Get.isRegistered<MyFoodtruckController>()) {
      final mcontroller = Get.find<MyFoodtruckController>();
      mcontroller.update();
    }*/

    Get.back();
  }

  Future<void> updateFoodTruck() async {
    final Map<String, dynamic> paymentOptions = {
      'cash': cash.value,
      'card': card.value,
      'bankTransfer': bankTransfer.value,
      'bankName': bankController.value.text,
      'accountName': accountHolderController.value.text,
      'accountNumber': accountNumberController.value.text,
    };

    await _foodTruckModel.updateFoodTruck(
        foodtruckid,
        nameController.value.text,
        descriptionController.value.text,
        scheduleController.value.text,
        phoneController.value.text,
        paymentOptions,
        file,
        tagController.value.text,
        jlatitude,
        jlongitude);
    await foodtruckController.ObsgetFoodTruckData(); // 목록페이지 데이터 갱신
  }

  Future<File?> getFoodTruckImgGaller() async {
    // 갤러리에서 이미지를 선택하여 파일을 가져옵니다.
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  void getText() {
    nameController.value.text = foodtruck["truck_name"];
    scheduleController.value.text = foodtruck["truck_schedule"];
    bankController.value.text = foodtruck["truck_payment"]["bankName"];
    tagController.value.text = foodtruck["truck_tag"];
    phoneController.value.text = foodtruck["truck_name"];
    accountHolderController.value.text =
        foodtruck["truck_payment"]["accountName"];
    accountNumberController.value.text =
        foodtruck["truck_payment"]["accountNumber"];
    descriptionController.value.text = foodtruck["truck_description"];

    cash.value = foodtruck["truck_payment"]["cash"];
    card.value = foodtruck["truck_payment"]["card"];
    bankTransfer.value = foodtruck["truck_payment"]["bankTransfer"];
    jlatitude = foodtruck["truck_latitude"];
    jlongitude = foodtruck["truck_longitude"];
  }
}
