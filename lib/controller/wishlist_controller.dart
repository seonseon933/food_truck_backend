import 'package:food_truck/controller/base_controller.dart';
import 'package:food_truck/view/wishlist_view.dart';
import '../view/foodtruckdetail_view.dart';
import 'package:get/get.dart';
import 'app_pages.dart';
import 'package:flutter/material.dart';
import 'app_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_truck/model/favorite_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/foodtruck_model.dart';

class WishlistController extends GetxController {
  final _store = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FavoriteModel _favoriteModel = FavoriteModel();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  void goDetail(seletIndex) {
    //print(seletIndex);
    Get.toNamed(Routes.FOODTRUCKDETAIL, arguments: seletIndex);
  }

  Future<List<String>> getFavoriteTruckData(String uid) async {
    //print(await _foodTruckModel.getFavoriteFoodTruck(uid));

    return await _foodTruckModel.getFavoriteFoodTruck(uid);
  }

  Future<Map<String, dynamic>> getFoodTruckData(
      String uid, String truckid) async {
    return await _foodTruckModel.getDetailFoodTruck(truckid);
  }

  Future<void> favoriteTruckInsert(String foodtruckid) async {
    User user = _auth.currentUser!;
    _favoriteModel.favoriteFoodTruckCreate(foodtruckid, user.uid);
  }

  Future<void> favoriteFoodTruckDelete(String foodtruckid, String uid) async {
    return _favoriteModel.favoriteFoodTruckDelete(foodtruckid, uid);
  }
}

class WishlistWrapper extends StatelessWidget {
  const WishlistWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(wishlistD),
      initialRoute: Routes.WISHLIST,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.WISHLIST) {
          return GetPageRoute(
              routeName: Routes.WISHLIST,
              page: () => const WishlistView(),
              binding: WishlistBinding());
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
