import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/review_model.dart';

class ReviewController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ReviewModel _reviewModel = ReviewModel();

  // 해당 푸드트럭의 리뷰 전체 문서 불러오기
  Future<List<Map<String, dynamic>>> getFoodTruckReviewsData(
      String foodtruckId) async {
    return _reviewModel.getFoodTruckReviewsData(foodtruckId);
  }

  // 해당 사용자가 작성한 푸드트럭 리뷰 문서 데이터 불러오기
  Future<List<Map<String, dynamic>>> getUserReviewsData() async {
    User user = _auth.currentUser!;
    return _reviewModel.getUserReviewsData(user.uid);
  }

  Future<String> createReview(
      String foodtruckid, double rating, String reviewContext) async {
    User user = _auth.currentUser!;
    return _reviewModel.createReview(
        foodtruckid, user.uid, rating, reviewContext);
  }

  Future<String> updateReview(String foodtruckid, String reviewid,
      double rating, String reviewContext) async {
    return _reviewModel.updateReview(
        foodtruckid, reviewid, rating, reviewContext);
  }

  Future<String> deleteReview(String foodtruckid, String reviewid) async {
    User user = _auth.currentUser!;
    return _reviewModel.deleteReview(foodtruckid, reviewid, user.uid);
  }
}
