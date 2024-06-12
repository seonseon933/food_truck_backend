import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/controller/foodtruckdetail_controller.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:food_truck/view/writereview_view.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../view/foodtruckdetail_view.dart';
import 'package:get/get.dart';
import 'app_pages.dart';
import 'package:flutter/material.dart';
import 'app_id.dart';

class ReviewlistController extends GetxController {
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void goDetail(seletIndex) {
    //print(seletIndex);
    Get.toNamed(Routes.FOODTRUCKDETAIL, arguments: seletIndex);
  }

  Future<List<String>> getReviewFoodTruck(String uid) async {
    return await _foodTruckModel.getReviewFoodTruck(uid);
  }

  Future<Map<String, dynamic>> getFoodTruckData(
      String uid, String truckid) async {
    return await _foodTruckModel.getDetailFoodTruck(truckid);
  }
}

class FoodtruckWrapper extends StatelessWidget {
  const FoodtruckWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(100),
      initialRoute: Routes.REVIEW,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.REVIEW) {
          return GetPageRoute(
              routeName: Routes.REVIEW,
              page: () => const ReviewlistView(),
              binding: ReviewlistBinding());
        } else if (routeSettings.name == Routes.FOODTRUCKDETAIL) {
          return GetPageRoute(
              routeName: Routes.FOODTRUCKDETAIL,
              page: () => const FoodtruckdetailView(),
              binding: FoodtruckdetailBinding());
        }
        return null;
      },
    );
  }
}
