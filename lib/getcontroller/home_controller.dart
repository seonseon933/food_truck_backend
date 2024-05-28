import 'app_id.dart';
import '../view/home_view.dart';
//import 'package:food_truck/view/search_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_pages.dart';

class HomeController extends GetxController {}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(homeD),
      initialRoute: Routes.HOME,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.HOME) {
          return GetPageRoute(
              routeName: Routes.HOME,
              page: () => const HomeView(),
              binding: HomeBinding());
        } /* else if (routeSettings.name == Routes.SEARCH) {
          return GetPageRoute(
              routeName: Routes.SEARCH,
              page: () => const SearchView(),
              binding: SearchBinding());
        }*/
        return null;
      },
    );
  }
}
