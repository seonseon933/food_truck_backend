import 'package:get/get.dart';
import '../model/menu_model.dart';
import 'app_pages.dart';

class FoodtruckdetailController extends GetxController {
  final MenuModel _menuModel = MenuModel();

  void goSetting(foodtruckid) {
    //print(foodtruck);
    Get.offNamed(Routes.FOODTRUCKSETTING, arguments: foodtruckid);
  }

  getFoodTruckMenuData(String foodtruckId) async {
    return await _menuModel.getFoodTruckMenuData(foodtruckId);
  }
}
