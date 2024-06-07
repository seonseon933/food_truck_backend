import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/model/review_model.dart';
import 'package:get/get.dart';

import 'app_pages.dart';

class ReviewupdateController extends GetxController {
  final ReviewModel _reviewModel = ReviewModel();
  final FoodtruckController foodtruckController =
      Get.find<FoodtruckController>();

  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  Future<void> updateReview(String foodtruckid, String reviewid, double rating,
      String reviewContext) async {
    await _reviewModel.updateReview(
        foodtruckid, reviewid, rating, reviewContext);
    await foodtruckController.ObsgetFoodTruckData(); // 목록페이지 데이터 갱신
  }
}
