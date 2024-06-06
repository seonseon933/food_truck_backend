import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruckupdate_controller.dart';
import 'package:get/get.dart';

import '../style/font_style.dart';

class FoodtruckupdateView extends StatefulWidget {
  const FoodtruckupdateView({Key? key}) : super(key: key);

  @override
  _FoodtruckupdateViewState createState() => _FoodtruckupdateViewState();
}

class _FoodtruckupdateViewState extends State<FoodtruckupdateView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxBool cash = false.obs;
  final RxBool card = false.obs;
  final RxBool bankTransfer = false.obs;

  @override
  void dispose() {
    // dispose 메소드에서 TextEditingController를 해제합니다.
    nameController.dispose();
    scheduleController.dispose();
    bankController.dispose();
    tagController.dispose();
    phoneController.dispose();
    accountHolderController.dispose();
    accountNumberController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final controller = Get.find<FoodtruckupdateController>();

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
                  Container(
                    width: size.width * 0.9,
                    height: size.height * 0.3,
                    child: Stack(
                      children: [
                        GetBuilder<FoodtruckupdateController>(
                          builder: (controller) => Container(
                            decoration: BoxDecoration(
                              image: controller.file != null
                                  ? DecorationImage(
                                      image: FileImage(controller.file!),
                                      fit: BoxFit.fill,
                                    )
                                  : DecorationImage(
                                      image: controller.fileimg as NetworkImage,
                                      fit: BoxFit.fill,
                                    ),
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.edit),
                              iconSize: 30,
                              onPressed: () async {
                                controller.file = await controller
                                    .getFoodTruckImgGaller() as File;
                                controller.update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      decoration: InputDecoration(
                        hintText: controller.foodtruck["truck_name"],
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
                      decoration: InputDecoration(
                        hintText: controller.foodtruck["truck_phone"],
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: controller.foodtruck["truck_tag"],
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
                      decoration: InputDecoration(
                        hintText: controller.foodtruck["truck_schedule"],
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: controller.foodtruck["truck_payment"]
                                ["bankName"],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('예금주', style: CustomTextStyles.body),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: controller.foodtruck["truck_payment"]
                                ["accountName"], // 성명 입력 박스
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: controller.foodtruck["truck_payment"]
                        ["accountNumber"], // 계좌번호 입력 박스
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                    hintText:
                        controller.foodtruck["truck_description"], // 설명 입력 박스
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      nameController.text =
                          controller.foodtruck["truck_name"] ?? "";
                    }
                    if (descriptionController.text.isEmpty) {
                      descriptionController.text =
                          controller.foodtruck["truck_description"] ?? "";
                    }
                    if (scheduleController.text.isEmpty) {
                      scheduleController.text =
                          controller.foodtruck["truck_schedule"] ?? "";
                    }
                    if (phoneController.text.isEmpty) {
                      phoneController.text =
                          controller.foodtruck["truck_phone"] ?? "";
                    }
                    if (bankController.text.isEmpty) {
                      bankController.text =
                          controller.foodtruck["bankName"] ?? "";
                    }
                    if (accountHolderController.text.isEmpty) {
                      accountHolderController.text =
                          controller.foodtruck["accountName"] ?? "";
                    }
                    if (accountNumberController.text.isEmpty) {
                      accountNumberController.text =
                          controller.foodtruck["accountNumber"] ?? "";
                    }
                    if (tagController.text.isEmpty) {
                      tagController.text =
                          controller.foodtruck["truck_tag"] ?? "";
                    }

                    Map<String, dynamic> paymentOptions = {
                      'cash': cash.value,
                      'card': card.value,
                      'bankTransfer': bankTransfer.value,
                      'bankName': bankController.text,
                      'accountName': accountHolderController.text,
                      'accountNumber': accountNumberController.text,
                    };

                    await controller.updateFoodTruck(
                      controller.foodtruckid,
                      nameController.text,
                      descriptionController.text,
                      scheduleController.text,
                      phoneController.text,
                      paymentOptions,
                      controller.file,
                      tagController.text,
                      controller.jlatitude,
                      controller.jlongitude,
                    );

                    print('등록버튼 클릭');

                    controller.goDetail();
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
