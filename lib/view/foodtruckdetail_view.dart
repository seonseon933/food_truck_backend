import 'package:flutter/material.dart';
import 'package:food_truck/getcontroller/foodtruckdetail_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';

class FoodtruckdetailView extends GetView<FoodtruckdetailController> {
  const FoodtruckdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> foodtruck =
        Get.arguments as Map<String, dynamic>;
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

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 36,
              height: 36,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit),
                onPressed: () {
                  controller.goSetting(foodtruck['foodtruck_id']);
                },
              ),
            ),
          ),
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
          const DefaultTabController(
            length: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                TabBar(
                  tabs: [
                    Tab(text: '메뉴'),
                    Tab(text: '정보'),
                    Tab(text: '리뷰'),
                  ],
                ),
                /*
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      FutureBuilder<List<dynamic>>(
                          future: controller.getFoodTruckMenuData(select),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data.isEmpty) {
                              return const Center(
                                  child: Text('No data available'));
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    final menu = snapshot.data[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.height * 0.2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(
                                                    0, 3), // 그림자 위치 설정
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                menu['menu_img'], // 이미지 URL
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            title: Text(menu['menu_name'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '설명: ${menu['menu_description']}'),
                                                Text(
                                                    '가격: ${menu['menu_price']}'),
                                              ],
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                ),
                              );
                            }
                          }),
                      Center(child: Text('정보 탭 내용')),
                      Center(child: Text('리뷰 탭 내용')),
                    ],
                  ),
                ),*/
              ],
            ),
          )
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
