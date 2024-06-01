import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/review_model.dart';
import 'package:get/get.dart';

import 'app_pages.dart';

class ReviewsettingController extends GetxController {
  final ReviewModel _reviewModel = ReviewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  Future<String> createReview(
      String foodtruckid, double rating, String reviewContext) async {
    User user = _auth.currentUser!;
    return await _reviewModel.createReview(
        foodtruckid, user.uid, rating, reviewContext);
  }
}
