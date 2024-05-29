import 'package:food_truck/getcontroller/base_controller.dart';
import 'package:food_truck/getcontroller/foodtruck_controller.dart';
import 'package:food_truck/getcontroller/foodtrucksetting_controller.dart';
import 'package:food_truck/view/base_view.dart';
import 'package:food_truck/view/foodtruck_view.dart';
import 'package:food_truck/view/foodtrucksetting_view.dart';
import 'package:get/get.dart';

import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:food_truck/getcontroller/foodtruckdetail_controller.dart';

import '../view/home_view.dart';
import '../getcontroller/home_controller.dart';

import '../view/login_view.dart';
import 'package:food_truck/getcontroller/login_controller.dart';

import '../view/first_login.dart';

part 'app_routes.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(
      () => BaseController(),
    );
  }
}

class FoodtruckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodtruckController>(
      () => FoodtruckController(),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}

class FirstLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}

class FoodtrucksettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodtrucksettingController>(
      () => FoodtrucksettingController(),
    );
  }
}

class FoodtruckdetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodtruckdetailController>(
      () => FoodtruckdetailController(),
    );
  }
}

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FIRSTLOGIN,
      page: () => const FirstLogin(),
      binding: FirstLoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCKDETAIL,
      page: () => const FoodtruckdetailView(),
      binding: FoodtruckdetailBinding(),
    ),
    GetPage(
      name: _Paths.BASE,
      page: () => const BaseView(),
      binding: BaseBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCK,
      page: () => const FoodtruckView(),
      binding: FoodtruckBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCKSETTING,
      page: () => const FoodtrucksettingView(),
      binding: FoodtrucksettingBinding(),
    ),
  ];
}
