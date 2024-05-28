import 'package:flutter/material.dart';
//import 'search_view.dart';
import 'package:get/get.dart';
import 'package:food_truck/getcontroller/home_controller.dart';
//import '../controller/search_controller.dart';
import '../style/font_style.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              InkWell(
                // 누르면 버튼 효과
                highlightColor: Colors.black12,
                // Container와 동일한 Radius 설정
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  Get.lazyPut<Search_Controller>(
                    () => Search_Controller(),
                  );
                  Get.dialog(
                    Theme(
                      data: Theme.of(context),
                      child: AlertDialog(
                        content: SearchView(),
                      ),
                    ),
                  );
                },

                child: Container(
                  width: size.width * 0.7,
                  padding: const EdgeInsets.all(8.0),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.search,
                          color: Color(0xff7d7d7d),
                          size: 20.0,
                        ),
                      ),
                      Text("주소를 입력하세요", style: CustomTextStyles.caption)
                    ],
                  ),
                ),
              ),
              */
              SizedBox(
                height: size.height * 0.005,
              ),
              Container(
                width: size.width * 0.9,
                height: size.height * 0.7,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
