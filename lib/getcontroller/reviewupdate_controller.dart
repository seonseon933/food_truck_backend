import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/review_model.dart';
import 'package:get/get.dart';

import 'app_pages.dart';

class ReviewupdateController extends GetxController {
  final ReviewModel _reviewModel = ReviewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  Future<String> updateReview(String foodtruckid, String reviewid,
      double rating, String reviewContext) async {
    return _reviewModel.updateReview(
        foodtruckid, reviewid, rating, reviewContext);
  }
}
