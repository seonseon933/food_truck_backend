import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/controller/foodtruckdetail_controller.dart';
import 'package:food_truck/controller/writereview_controller.dart';
import 'package:food_truck/model/review_model.dart';
import 'package:get/get.dart';

import 'app_pages.dart';

class ReviewsettingController extends GetxController {
  final ReviewModel _reviewModel = ReviewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FoodtruckController foodtruckController =
      Get.find<FoodtruckController>(); // add
  final FoodtruckdetailController foodtruckdetailController =
      Get.find<FoodtruckdetailController>();

  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  Future<void> createReview(
      String foodtruckid, double rating, String reviewContext) async {
    User user = _auth.currentUser!;
    await _reviewModel.createReview(
        foodtruckid, user.uid, rating, reviewContext);
    await foodtruckController.ObsgetFoodTruckData(); // 목록페이지 데이터 갱신
    // 중복되지 않는 foodtruckid 추가
    if (!foodtruckdetailController.reviewTruckIds.contains(foodtruckid)) {
      foodtruckdetailController.reviewTruckIds.add(foodtruckid);
    }
  }
}
