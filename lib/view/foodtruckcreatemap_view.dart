import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:food_truck/controller/foodtruckcreate_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../view/navermap_view.dart';
import '../view/search_view.dart';
import '../controller/search_controller.dart';
import '../style/font_style.dart';

class FoodtruckcreatemapView extends GetView<FoodtruckcreateController> {
  const FoodtruckcreatemapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('푸드트럭 등록')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              Center(
                child: InkWell(
                  // 누르면 버튼 효과
                  highlightColor: Colors.black12,
                  // Container와 동일한 Radius 설정
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () async {
                    Get.lazyPut<Search_Controller>(
                      () => Search_Controller(),
                    );
                    final juso = await Get.dialog(
                      Theme(
                        data: Theme.of(context),
                        child: AlertDialog(
                          content: SearchView(),
                        ),
                      ),
                    );
                    controller.juso.value = juso;
                    print("search = ${juso}");
                  },

                  child: Container(
                    width: size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
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
              ),
              SizedBox(height: size.height * 0.02),
              Center(
                child: Container(
                  width: size.width * 0.85,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() => CNaverMapApp(
                        juso: controller.juso.value,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
