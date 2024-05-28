import 'package:flutter/material.dart';
import 'package:food_truck/getcontroller/foodtruckdetail_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';

class FoodtruckdetailView extends GetView<FoodtruckdetailController> {
  const FoodtruckdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final foodtruck = Get.arguments as Map<String, dynamic>;
    final String select = foodtruck['foodtruck_id'];
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(foodtruck['truck_name']),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 이미지 추가
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(foodtruck['truck_img']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(11.0),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            "${foodtruck['truck_name']}",
            style: CustomTextStyles.title,
          ),
          const SizedBox(height: 10),
          // 위치 및 거리 정보 추가
          Row(
            children: [
              const Text(
                "위치:",
                style: CustomTextStyles.body,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  foodtruck['truck_address'],
                  style: CustomTextStyles.body,
                  softWrap: true, // 텍스트 줄 바꿈 허용
                  overflow: TextOverflow.visible, // 텍스트가 경계를 넘을 경우 클립하지 않음
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 결제 방법 추가
          const Text(
            "결제 방법:",
            style: CustomTextStyles.subtitle,
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: _buildPaymentMethodsWidget(foodtruck['truck_payment']),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "운영 시간:",
                style: CustomTextStyles.subtitle,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  foodtruck['truck_schedule'],
                  style: CustomTextStyles.body,
                  softWrap: true, // 텍스트 줄 바꿈 허용
                  overflow: TextOverflow.visible, // 텍스트가 경계를 넘을 경우 클립하지 않음
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsWidget(Map<String, dynamic> truckPayment) {
    List<String> paymentMethods = [];

    if (truckPayment['cash'] == true) {
      paymentMethods.add("현금");
    }

    if (truckPayment['card'] == true) {
      paymentMethods.add("카드");
    }

    if (truckPayment['bankTransfer'] == true) {
      paymentMethods.add("계좌이체");
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: paymentMethods.join(" "),
            style: CustomTextStyles.body,
          ),
          if (truckPayment['bankTransfer'] == true) ...[
            TextSpan(
                text: '\n은행: ${truckPayment['bankName']}',
                style: CustomTextStyles.body),
            TextSpan(
                text: '\n예금주: ${truckPayment['accountName']}',
                style: CustomTextStyles.body),
            TextSpan(
                text: '\n계좌: ${truckPayment['accountNumber']}',
                style: CustomTextStyles.body),
          ],
        ],
      ),
    );
  }
}
