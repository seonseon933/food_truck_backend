import 'package:flutter/material.dart';
import 'package:food_truck/controller/app_pages.dart';
import '../controller/app_id.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:image_picker/image_picker.dart';

class FoodtruckcreateController extends GetxController {
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

  File? file;
  late final jlatitude;
  late final jlongitude;
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  @override
  void onInit() {
    super.onInit();
    jlatitude = Get.arguments["truck_latitude"];
    jlongitude = Get.arguments["truck_longitude"];
  }

  void goProfile() {
    Get.back();
    Get.snackbar(
      '',
      '',
      titleText: Container(),
      messageText: const Text(
        "푸드트럭생성에 성공했습니다.",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
    );
  }

  getFoodTruckImgGaller() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }

  createFoodTruck(
    String truckName,
    String truckDescription,
    String truckSchedule,
    String truckPhone,
    Map<String, dynamic> paymentOptions,
    File? file,
    String truckTag,
  ) {
    User user = _auth.currentUser!;
    return _foodTruckModel.createFoodTruck(
        truckName,
        truckDescription,
        truckSchedule,
        truckPhone,
        paymentOptions,
        file,
        truckTag,
        user.uid,
        jlatitude,
        jlongitude);
  }
}
