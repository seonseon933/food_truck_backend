import 'package:food_truck/controller/profilesetting_controller.dart';
import 'package:food_truck/view/profilesetting_view.dart';
import 'package:get/get.dart';

import 'package:food_truck/controller/base_controller.dart';
import 'package:food_truck/view/base_view.dart';

import '../view/first_login.dart';

import 'package:food_truck/controller/profile_controller.dart';
import 'package:food_truck/view/profile_view.dart';

import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/view/foodtruck_view.dart';

import 'package:food_truck/view/foodtruckupdatemap_view.dart';
import 'package:food_truck/controller/foodtruckupdatemap_controller.dart';

import 'package:food_truck/view/foodtruckdetail_view.dart';
import 'package:food_truck/controller/foodtruckdetail_controller.dart';

import '../view/home_view.dart';
import 'home_controller.dart';

import '../view/login_view.dart';
import 'package:food_truck/controller/login_controller.dart';

import 'package:food_truck/view/foodtruckupdate_view.dart';
import 'package:food_truck/controller/foodtruckupdate_controller.dart';

import 'package:food_truck/controller/menusetting_controller.dart';
import 'package:food_truck/view/menusetting_view.dart';

import 'package:food_truck/controller/menuupdate_controller.dart';
import 'package:food_truck/view/menuupdate_view.dart';

import 'package:food_truck/controller/reviewsetting_controller.dart';
import 'package:food_truck/view/reviewsetting_view.dart';

import 'package:food_truck/controller/reviewupdate_controller.dart';
import 'package:food_truck/view/reviewupdate_view.dart';

import 'foodtruckcreate_controller.dart';
import '../view/foodtruckcreate_view.dart';

import '../view/foodtruckcreatemap_view.dart';
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

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}

class ProfilesettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilesettingController>(
      () => ProfilesettingController(),
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

class FoodtruckupdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodtruckupdateController>(
      () => FoodtruckupdateController(),
    );
  }
}

class FoodtruckupdatemapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodtruckupdatemapController>(
      () => FoodtruckupdatemapController(),
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

class MenusettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenusettingController>(
      () => MenusettingController(),
    );
  }
}

class MenuupdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuupdateController>(
      () => MenuupdateController(),
    );
  }
}

class ReviewsettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsettingController>(
      () => ReviewsettingController(),
    );
  }
}

class ReviewupdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewupdateController>(
      () => ReviewupdateController(),
    );
  }
}

class FoodtruckcreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodtruckcreateController>(
      () => FoodtruckcreateController(),
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
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROFILESETTING,
      page: () => const ProfilesettingView(),
      binding: ProfilesettingBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCKUPDATE,
      page: () => const FoodtruckupdateView(),
      binding: FoodtruckupdateBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCKUPDATEMAP,
      page: () => const FoodtruckupdatemapView(),
      binding: FoodtruckupdatemapBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCKCREATE,
      page: () => const FoodtruckcreateView(),
      binding: FoodtruckcreateBinding(),
    ),
    GetPage(
      name: _Paths.FOODTRUCKCREATEMAP,
      page: () => const FoodtruckcreatemapView(),
      binding: FoodtruckcreateBinding(),
    ),
    GetPage(
      name: _Paths.MENUSETTING,
      page: () => const MenusettingView(),
      binding: MenusettingBinding(),
    ),
    GetPage(
      name: _Paths.MENUUPDATE,
      page: () => const MenudateView(),
      binding: MenuupdateBinding(),
    ),
    GetPage(
      name: _Paths.REVIEWSETTING,
      page: () => const ReviewsettingView(),
      binding: ReviewsettingBinding(),
    ),
    GetPage(
      name: _Paths.REVIEWUPDATE,
      page: () => const ReviewupdateView(),
      binding: ReviewupdateBinding(),
    ),
  ];
}
