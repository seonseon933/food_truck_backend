import 'package:food_truck/model/foodtruck_model.dart';
import 'package:get/get.dart';
import '../model/menu_model.dart';
import 'app_pages.dart';

class FoodtruckdetailController extends GetxController {
  final MenuModel _menuModel = MenuModel();
  final FoodTruckModel _foodTruckModel = FoodTruckModel();

  var foodtruckid = ''.obs;

  void setFoodTruckId(String id) {
    foodtruckid.value = id;
  }

  void goUpdateMap(foodtruck) {
    Get.toNamed(Routes.FOODTRUCKUPDATEMAP, arguments: foodtruck);
    // Get.offNamed(Routes.FOODTRUCKUPDATEMAP, arguments: foodtruck);
  }

  // 상세 푸드트럭
  Future<Map<String, dynamic>> getDetailFoodTruck(String foodtruckid) async {
    return _foodTruckModel.getDetailFoodTruck(foodtruckid);
  }

  // 메뉴 불러오기
  Future<List<Map<String, dynamic>>> getFoodTruckMenuData(
      String foodtruckId) async {
    return await _menuModel.getFoodTruckMenuData(foodtruckId);
  }

  // getFoodTruckMenuData(String foodtruckId) async {
  //   return await _menuModel.getFoodTruckMenuData(foodtruckId);
  // }
}
