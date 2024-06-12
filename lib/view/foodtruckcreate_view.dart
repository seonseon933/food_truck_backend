import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruckcreate_controller.dart';
import 'package:food_truck/oldcontroller/foodtruck_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';

class FoodtruckcreateView extends GetView<FoodTruckController> {
  const FoodtruckcreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final controller = Get.find<FoodtruckcreateController>();

    return Scaffold(
      appBar: AppBar(title: const Text('푸드트럭 등록')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.3,
                    child: Stack(
                      children: [
                        GetBuilder<FoodtruckcreateController>(
                          builder: (controller) => Container(
                            decoration: BoxDecoration(
                              image: controller.file != null
                                  ? DecorationImage(
                                      image: FileImage(controller.file!),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                            child: controller.file == null
                                ? const Center(
                                    child: Text('선택된 이미지가 없습니다.'),
                                  )
                                : null,
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
                                    .getFoodTruckImgGaller() as File?;
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
              const Text('푸드트럭 이름', style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              TextField(
                controller: controller.nameController.value,
                decoration: const InputDecoration(
                  hintText: '푸드트럭 이름 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('푸드트럭 정보', style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController.value,
                      decoration: const InputDecoration(
                        hintText: '전화번호 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: controller.tagController.value,
                      decoration: const InputDecoration(
                        hintText: '음식 태그입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: controller.scheduleController.value,
                decoration: const InputDecoration(
                  hintText: '판매요일/시간 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('결제 방법', style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: controller.cash.value,
                          onChanged: (bool? value) {
                            controller.cash.value = value!;
                          })),
                      const Text('현금', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: controller.card.value,
                          onChanged: (bool? value) {
                            controller.card.value = value!;
                          })),
                      const Text('카드', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: controller.bankTransfer.value,
                          onChanged: (bool? value) {
                            controller.bankTransfer.value = value!;
                          })),
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
                      const Text('은행', style: CustomTextStyles.body),
                      const SizedBox(height: 4.0),
                      Container(
                        width: 120.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: controller.bankController.value,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            hintText: '은행 입력',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('성명', style: CustomTextStyles.body),
                      const SizedBox(height: 4.0),
                      Container(
                        width: 120.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: controller.accountHolderController.value,
                          decoration: const InputDecoration(
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
              const SizedBox(height: 16.0),
              const Text('계좌번호', style: CustomTextStyles.body),
              const SizedBox(height: 4.0),
              Container(
                width: 250.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: controller.accountNumberController.value,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: '계좌번호 입력',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('설명', style: CustomTextStyles.title),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: controller.descriptionController.value,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: '설명 입력',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black87,
                      shadowColor: Colors.grey[300],
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    onPressed: () async {
                      Map<String, dynamic> paymentOptions = {
                        'cash': controller.cash.value,
                        'card': controller.card.value,
                        'bankTransfer': controller.bankTransfer.value,
                        'bankName': controller.bankController.value.text,
                        'accountName':
                            controller.accountHolderController.value.text,
                        'accountNumber':
                            controller.accountNumberController.value.text,
                      };
                      await controller.createFoodTruck(
                        controller.nameController.value.text,
                        controller.descriptionController.value.text,
                        controller.scheduleController.value.text,
                        controller.phoneController.value.text,
                        paymentOptions,
                        controller.file,
                        controller.tagController.value.text,
                      );
                      controller.goProfile();
                    },
                    child: const Text("등 록", style: CustomTextStyles.bodyBold),
                  ),
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
