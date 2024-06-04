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

class FoodtruckcreateView extends GetView<FoodtruckcreateController> {
  const FoodtruckcreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final nameController = TextEditingController();
    final scheduleController = TextEditingController();
    final bankController = TextEditingController();
    final tagController = TextEditingController();
    final phoneController = TextEditingController();
    final accountHolderController = TextEditingController();
    final accountNumberController = TextEditingController();
    final descriptionController = TextEditingController();
    RxBool cash = false.obs;
    RxBool card = false.obs;
    RxBool bankTransfer = false.obs;
    return Scaffold(
      appBar: AppBar(title: Text('푸드트럭 등록')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/foodtruck_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              controller.getFoodTruckImgGaller();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
              SizedBox(height: 16.0),
              Text('푸드트럭 이름', style: CustomTextStyles.title),
              SizedBox(height: 8.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: '푸드트럭 이름 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('푸드트럭 정보', style: CustomTextStyles.title),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: '전화번호 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: '음식 태그',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: scheduleController,
                decoration: InputDecoration(
                  hintText: '판매요일/시간 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('결제 방법', style: CustomTextStyles.title),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: cash.value,
                          onChanged: (bool? value) {
                            cash.value = value!;
                          })),
                      Text('현금', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: card.value,
                          onChanged: (bool? value) {
                            card.value = value!;
                          })),
                      Text('카드', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: bankTransfer.value,
                          onChanged: (bool? value) {
                            bankTransfer.value = value!;
                          })),
                      Text('계좌이체', style: CustomTextStyles.body),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('은행', style: CustomTextStyles.body),
                      SizedBox(height: 4.0),
                      Container(
                        width: 120.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: bankController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: '은행 입력',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('성명', style: CustomTextStyles.body),
                      SizedBox(height: 4.0),
                      Container(
                        width: 120.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: accountHolderController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: '성명 입력',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('계좌번호', style: CustomTextStyles.body),
              SizedBox(height: 4.0),
              Container(
                width: 250.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: accountNumberController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: '계좌번호 입력',
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text('설명', style: CustomTextStyles.title),
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: '설명 입력',
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> paymentOptions = {
                      'cash': cash.value,
                      'card': card.value,
                      'bankTransfer': bankTransfer.value,
                      'bankName': bankController.text,
                      'accountName': accountHolderController.text,
                      'accountNumber': accountNumberController.text,
                    };
                    controller.createFoodTruck(
                      nameController.text,
                      descriptionController.text,
                      scheduleController.text,
                      phoneController.text,
                      paymentOptions,
                      File('null'),
                      tagController.text,
                    );
                    print('등록버튼 클릭');
                    controller.goBack();
                  },
                  child: Text('등록'),
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
