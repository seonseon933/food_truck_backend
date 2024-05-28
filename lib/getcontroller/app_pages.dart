import 'package:get/get.dart';

import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:food_truck/getcontroller/foodtruckdetail_controller.dart';

import '../view/home_view.dart';
import '../getcontroller/home_controller.dart';

import '../view/login_view.dart';
import 'package:food_truck/getcontroller/login_controller.dart';

import '../view/first_login.dart';

part 'app_routes.dart';

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
  ];
}
