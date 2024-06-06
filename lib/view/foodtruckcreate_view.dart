import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruckcreate_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';

class FoodtruckcreateView extends GetView<FoodtruckcreateController> {
  const FoodtruckcreateView({super.key});

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
                  Container(
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
                                ? Center(
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
                controller: nameController,
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
              TextField(
                controller: scheduleController,
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
                          value: cash.value,
                          onChanged: (bool? value) {
                            cash.value = value!;
                          })),
                      const Text('현금', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: card.value,
                          onChanged: (bool? value) {
                            card.value = value!;
                          })),
                      const Text('카드', style: CustomTextStyles.body),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: bankTransfer.value,
                          onChanged: (bool? value) {
                            bankTransfer.value = value!;
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
                          controller: bankController,
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
                          controller: accountHolderController,
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
                  controller: accountNumberController,
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
                  controller: descriptionController,
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
                      controller.file,
                      tagController.text,
                    );
                    print('등록버튼 클릭');
                    controller.goProfile();
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
