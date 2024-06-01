import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruckupdate_controller.dart';
import 'package:get/get.dart';

import '../style/font_style.dart';

class FoodtruckupdateView extends GetView<FoodtruckupdateController> {
  const FoodtruckupdateView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = Get.arguments as Map;

    final String foodtruckid = arguments['foodtruck_id'];
    final double latitude = arguments['latitude'];
    final double longitude = arguments['longitude'];
    // TextEditingControllers for each text field
    final nameController = TextEditingController();
    final scheduleController = TextEditingController();
    final bankController = TextEditingController();
    final tagController = TextEditingController();
    final phoneController = TextEditingController();
    final accountHolderController = TextEditingController();
    final accountNumberController = TextEditingController();
    final descriptionController = TextEditingController();
    File? file;
    RxBool cash = false.obs;
    RxBool card = false.obs;
    RxBool bankTransfer = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('푸드트럭 수정'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    // backgroundImage: NetworkImage(profileimg), // 이미지 추가
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                      onPressed: () async {
                        file = await controller.getFoodTruckImgGaller();
                      },
                      child: const Text('사진 변경'))
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('푸드트럭 이름', // 푸드트럭 이름 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: '푸드트럭 이름 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('푸드트럭 정보', // 시간 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: '전화번호 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: tagController,
                      decoration: const InputDecoration(
                        hintText: '음식 태그',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: scheduleController,
                      decoration: const InputDecoration(
                        hintText: '판매요일/시간 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              const Text('결제 방법', // 결제 방법 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: cash.value,
                          onChanged: (bool? value) {
                            cash.value = value!;
                          })), // 현금 체크박스
                      const Text('현금', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: card.value,
                          onChanged: (bool? value) {
                            card.value = value!;
                          })), // 카드 체크박스
                      const Text('카드', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: bankTransfer.value,
                          onChanged: (bool? value) {
                            bankTransfer.value = value!;
                          })), // 계좌이체 체크박스
                      const Text('계좌이체', style: CustomTextStyles.body),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('은행', style: CustomTextStyles.body), // 은행 텍스트
                      const SizedBox(height: 4.0),
                      Container(
                        width: 120.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: bankController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: '은행 입력', // 은행 입력 박스
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0), // 간격 조절
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('예금주', style: CustomTextStyles.body), // 성명 텍스트
                      const SizedBox(height: 4.0),
                      Container(
                        width: 120.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: accountHolderController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: '예금주 입력', // 성명 입력 박스
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text('계좌번호', style: CustomTextStyles.body), // 계좌번호 텍스트
              const SizedBox(height: 4.0),
              Container(
                width: 250.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: accountNumberController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: '계좌번호 입력', // 계좌번호 입력 박스
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('설명', // 설명 텍스트
                  style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null, // 다중 라인 입력을 가능하게 함
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: '설명 입력', // 설명 입력 박스
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> paymentOptions = {
                      'cash': cash.value,
                      'card': card.value,
                      'bankTransfer': bankTransfer.value,
                      'bankName': bankController.text,
                      'accountName': accountHolderController.text,
                      'accountNumber': accountNumberController.text,
                    };
                    await controller.updateFoodTruck(
                        foodtruckid,
                        nameController.text,
                        descriptionController.text,
                        scheduleController.text,
                        phoneController.text,
                        paymentOptions,
                        file,
                        tagController.text,
                        latitude,
                        longitude);
                    print('등록버튼 클릭');
                    Map<String, dynamic> foodtruck =
                        await controller.getDetailFoodTruck(foodtruckid);
                    controller.goDetail(foodtruck);
                  },
                  child: const Text('등록'),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
