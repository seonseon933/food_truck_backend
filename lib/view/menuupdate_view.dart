import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_truck/controller/menuupdate_controller.dart';
import 'package:food_truck/style/font_style.dart';
import 'package:get/get.dart';

class MenudateView extends GetView<MenuupdateController> {
  const MenudateView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = Get.arguments as Map;
    final foodtruckid = arguments['foodtruck_id'];
    final menuid = arguments['menu_id'];
    final Map<String, dynamic> foodtruck = {'foodtruck_id': foodtruckid};

    // TextEditingControllers for each text field
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    File? file;

    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴 수정'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                      onPressed: () async {
                        file = await controller.getFoodTruckImgGaller();
                        print('메뉴 사진 값 : $file');
                      },
                      child: const Text('사진 변경'))
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('메뉴 이름', // 푸드트럭 이름 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: '메뉴 이름 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('메뉴 가격', // 시간 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: '메뉴 가격 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('메뉴 소개', // 시간 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: '메뉴 소개 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.updateMenu(
                        foodtruckid,
                        menuid,
                        nameController.text,
                        priceController.text,
                        descriptionController.text,
                        file);
                    controller.goDetail(foodtruck);
                  },
                  child: const Text('등록'),
                ),
              ),
            ]),
          )),
    );
  }
}
