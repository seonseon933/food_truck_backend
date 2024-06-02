import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/base_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Obx(() =>
            controller.widgetOptions.elementAt(controller.selectedIndex.value)),
        bottomNavigationBar: SizedBox(
          height: size.height * 0.1,
          child: Obx(() => BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.favorite),
                  //   label: 'Whislist',
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.food_bank),
                    label: 'Food',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: controller.selectedIndex.value,
                onTap: controller.onItemTapped,
              )),
        ));
  }
}
