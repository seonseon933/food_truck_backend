import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';
import 'package:food_truck/model/review_model.dart';
import 'package:get/get.dart';
import '../model/menu_model.dart';
import 'app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_truck/model/favorite_model.dart';

class FoodtruckdetailController extends GetxController {
  late RxList<String> favoriteTruckIds;
  final _store = FirebaseFirestore.instance;
  final MenuModel _menuModel = MenuModel();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  final ReviewModel _reviewModel = ReviewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FavoriteModel _favoriteModel = FavoriteModel();
  var foodtruckid = ''.obs;
  var menuList = <Map<String, dynamic>>[].obs;
  var reviewList = <Map<String, dynamic>>[].obs;

  void setFoodTruckId(String id) {
    foodtruckid.value = id;
    fetchMenuData(id); // FoodTruckId가 설정될 때 메뉴 데이터를 가져옴
    fetchReviewData(id);
  }

  void goUpdateMap(foodtruck) {
    Get.toNamed(Routes.FOODTRUCKUPDATEMAP, arguments: foodtruck);
  }

  void goMenuSetting(foodtruck) {
    Get.offNamed(Routes.MENUSETTING, arguments: foodtruck);
  }

  void goMenuUpdate(foodtruck) {
    Get.offNamed(Routes.MENUUPDATE, arguments: foodtruck);
  }

  void goMenuDelete(String foodtruckid, String menuid) async {
    await deleteMenu(foodtruckid, menuid);
    fetchMenuData(foodtruckid); // 삭제 후 메뉴 데이터를 다시 가져옴
  }

  void goReviewSetting(foodtruck) {
    Get.offNamed(Routes.REVIEWSETTING, arguments: foodtruck);
  }

  void goReviewUpdate(foodtruck) {
    Get.offNamed(Routes.REVIEWUPDATE, arguments: foodtruck);
  }

  void goReviewDelete(String foodtruckid, String reviewid) async {
    await deleteReview(foodtruckid, reviewid);
    fetchReviewData(foodtruckid); // 데이터 다시 가져오기
  }

  String getCurrentUseruid() {
    User user = _auth.currentUser!;
    return user.uid;
  }

  // 상세 푸드트럭
  Future<Map<String, dynamic>> getDetailFoodTruck(
      String foodtruckid, String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      favoriteTruckIds = RxList<String>.from(data['favorite_truckid']);
    } catch (e) {
      print('사용자 정보 가져오기 오류 : $e ');
    }
    return _foodTruckModel.getDetailFoodTruck(foodtruckid);
  }

  // 메뉴 데이터 가져오기
  Future<void> fetchMenuData(String foodtruckId) async {
    List<Map<String, dynamic>> menuData =
        await _menuModel.getFoodTruckMenuData(foodtruckId);
    menuList.value = menuData;
  }

  // 메뉴 삭제
  Future<void> deleteMenu(String foodtruckid, String menuid) async {
    await _menuModel.deleteMenu(foodtruckid, menuid);
  }

  // 리뷰 데이터 가져오기
  Future<void> fetchReviewData(String foodtruckId) async {
    List<Map<String, dynamic>> reviewData =
        await _reviewModel.getFoodTruckReviewsData(foodtruckId);
    reviewList.value = reviewData;
  }

  Future<String> deleteReview(String foodtruckid, String reviewid) async {
    User user = _auth.currentUser!;
    return _reviewModel.deleteReview(foodtruckid, reviewid, user.uid);
  }

  Future<void> favoriteTruckInsert(String foodtruckid) async {
    User user = _auth.currentUser!;
    _favoriteModel.favoriteFoodTruckCreate(foodtruckid, user.uid);
  }

  Future<void> favoriteFoodTruckDelete(String foodtruckid, String uid) async {
    return _favoriteModel.favoriteFoodTruckDelete(foodtruckid, uid);
  }
}
