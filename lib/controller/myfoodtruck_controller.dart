//import 'package:food_truck/view/foodtruck_view.dart';
//import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:food_truck/view/myfoodtruck_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_pages.dart';
import '../model/foodtruck_model.dart';

class MyFoodtruckController extends GetxController {
  final FoodTruckModel _foodTruckModel = FoodTruckModel();
  void goDetail(foodtruck) {
    Get.toNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck); // map 형태로 보냄
  }

  getFoodTruckData() async {
    return _foodTruckModel.getFoodTruckData();
  }
}

class FoodtruckWrapper extends StatelessWidget {
  const FoodtruckWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(100),
      initialRoute: Routes.MYFOODTRUCK,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.MYFOODTRUCK) {
          return GetPageRoute(
              routeName: Routes.MYFOODTRUCK,
              page: () => const MyFoodtruckView(),
              binding: MyFoodtruckBinding());
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
