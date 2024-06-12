//import 'package:food_truck/view/foodtruck_view.dart';
//import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:food_truck/view/foodtruck_view.dart';
import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_id.dart';
import 'app_pages.dart';
import '../model/foodtruck_model.dart';

class FoodtruckController extends GetxController {
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  var foodTrucks = <Map<String, dynamic>>[].obs;

  void goDetail(foodtruck) {
    Get.toNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck); // map 형태로 보냄
  }

  getFoodTruckData() async {
    return _foodTruckModel.getFoodTruckData();
  }

  Future<void> ObsgetFoodTruckData() async {
    // 여기에 데이터를 불러오는 로직을 추가하세요.
    List<Map<String, dynamic>> trucks =
        await _foodTruckModel.getFoodTruckData();
    foodTrucks.value = trucks;
  }

  @override
  void onInit() {
    super.onInit();
    ObsgetFoodTruckData();
  }

  @override //add
  void refresh() {
    ObsgetFoodTruckData();
  }
}

class FoodtruckWrapper extends StatelessWidget {
  const FoodtruckWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(foodtruckD),
      initialRoute: Routes.FOODTRUCK,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.FOODTRUCK) {
          return GetPageRoute(
              routeName: Routes.FOODTRUCK,
              page: () => const FoodtruckView(),
              binding: FoodtruckBinding());
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
