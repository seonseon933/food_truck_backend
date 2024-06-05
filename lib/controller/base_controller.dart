import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/controller/home_controller.dart';
import 'package:food_truck/controller/wishlist_controller.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class BaseController extends GetxController {
  RxInt selectedIndex = 0.obs;
  late List<Widget> widgetOptions;
  final userdata = Get.arguments;
  RxList<String> favoriteTruckIds = <String>[].obs;

  BaseController() {
    widgetOptions = <Widget>[
      const HomeWrapper(),
      const WishlistWrapper(),
      const FoodtruckWrapper(),
      const ProfileWrapper(),
    ];
  }

  void onItemTapped(int index) {
    //print((userdata as UserList).userDocID);
    selectedIndex.value = index;
  }
}
