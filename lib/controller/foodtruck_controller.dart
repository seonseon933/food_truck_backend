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
  var foodtrucks = <Map<String, dynamic>>[].obs;
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  @override
  void onInit() {
    super.onInit();
    print("onInit");
    fetchFoodTruckData();
  }

  goDetail(Map<String, dynamic> foodtruck) {
    Get.toNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  // Fetch data asynchronously and update the observable list
  Future<void> fetchFoodTruckData() async {
    final data = await _foodTruckModel.getFoodTruckData();
    foodtrucks.value = data;
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
