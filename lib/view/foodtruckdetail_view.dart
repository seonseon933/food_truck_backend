import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_truck/controller/base_controller.dart';
import 'package:food_truck/controller/foodtruckdetail_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';

class FoodtruckdetailView extends GetView<FoodtruckdetailController> {
  const FoodtruckdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final BaseController baseController = Get.find<BaseController>();
    final Map arguments = Get.arguments as Map;
    final String select = arguments['foodtruck_id'];
    controller.setFoodTruckId(select);
    // 수정, 삭제
    final Size size = MediaQuery.of(context).size;
    String uid = controller.getCurrentUseruid();

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: controller.getDetailFoodTruck(select),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('잘못된 접근입니다'));
          } else {
            Map<String, dynamic> foodtruck = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 이미지 추가
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(foodtruck['truck_img']),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (baseController.favoriteTruckIds
                            .contains(controller.foodtruckid.toString()))
                          SizedBox(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              iconSize: 35,
                              onPressed: () {
                                baseController.favoriteTruckIds
                                    .remove(controller.foodtruckid.toString());
                                controller.favoriteFoodTruckDelete(
                                    controller.foodtruckid.toString(), uid);
                              },
                            ),
                          )
                        else
                          SizedBox(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                              ),
                              iconSize: 35,
                              onPressed: () {
                                baseController.favoriteTruckIds
                                    .add(controller.foodtruckid.toString());
                                controller.favoriteTruckInsert(
                                    controller.foodtruckid.toString());
                              },
                            ),
                          ),
                        if (uid == foodtruck['user_uid']) ...[
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.edit),
                              iconSize: 30,
                              onPressed: () {
                                controller.goUpdateMap(foodtruck);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "${foodtruck['truck_name']}",
                    style: CustomTextStyles.truckname,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBarIndicator(
                      rating: foodtruck["truck_avgrating"] is int
                          ? (foodtruck["truck_avgrating"] as int).toDouble()
                          : foodtruck["truck_avgrating"] as double,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 30.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "(${foodtruck["truck_avgrating"].toString()})",
                      style: CustomTextStyles.caption,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.2,
                      height: size.height * 0.05,
                      child: const Text(
                        "결제 방법",
                        style: CustomTextStyles.body,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.65,
                      height: size.height * 0.05,
                      child: _buildPaymentMethodsWidget(
                          foodtruck['truck_payment']),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.2,
                      height: size.height * 0.05,
                      child: const Text(
                        "운영 시간",
                        style: CustomTextStyles.body,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: size.width * 0.65,
                      height: size.height * 0.05,
                      child: Text(
                        foodtruck['truck_schedule'],
                        style: CustomTextStyles.body,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: const Text(
                                '메뉴',
                                style: CustomTextStyles.bodyBold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: const Text(
                                '정보',
                                style: CustomTextStyles.bodyBold,
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: const Text(
                                '리뷰',
                                style: CustomTextStyles.bodyBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // 메뉴 탭 ====================================
                            buildMenuTab(context, select, uid,
                                foodtruck['user_uid'], size, controller),
                            // 정보 탭 ====================================
                            ListView(
                              padding: const EdgeInsets.all(16.0),
                              children: [
                                Text(
                                  '${foodtruck['truck_name']}',
                                  style: CustomTextStyles.title,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '운영 시간:',
                                  style: CustomTextStyles.subtitle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  foodtruck['truck_schedule'],
                                  style: CustomTextStyles.body,
                                ),

                                // 전화번호
                                const SizedBox(height: 20),
                                const Text(
                                  '전화번호:',
                                  style: CustomTextStyles.subtitle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  foodtruck['truck_phone'],
                                  style: CustomTextStyles.body,
                                ),
                                const SizedBox(height: 20),
                                // 수평선 추가
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 20),
                                // 푸드트럭 설명 추가
                                const Text(
                                  '푸드트럭 설명:',
                                  style: CustomTextStyles.subtitle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${foodtruck['truck_description']}',
                                  style: CustomTextStyles.body,
                                ),
                              ],
                            ),
                            // 리뷰 탭 ====================================
                            buildReviewTab(context, select, uid,
                                foodtruck['user_uid'], size, controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildMenuTab(BuildContext context, String select, String uid,
      String writeuid, Size size, FoodtruckdetailController controller) {
    final Map<String, dynamic> foodtruckidmap = {'foodtruck_id': select};
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (uid == writeuid) ...[
            ElevatedButton(
              onPressed: () {
                controller.goMenuSetting(foodtruckidmap);
              },
              child: const Text('메뉴 추가'),
            ),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: Obx(
              () {
                if (controller.menuList.isEmpty) {
                  return const Center(child: Text('등록된 메뉴가 없습니다.'));
                } else {
                  return ListView.builder(
                    itemCount: controller.menuList.length,
                    itemBuilder: (context, index) {
                      final menu = controller.menuList[index];
                      final Map<String, dynamic> foodtruckmenuidmap = {
                        'foodtruck_id': select,
                        'menu_id': menu['menu_id']
                      };
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: Image.network(
                                    menu['menu_img'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      menu['menu_name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (uid == writeuid) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: const Color.fromARGB(
                                          255, 175, 175, 175),
                                      onPressed: () {
                                        controller
                                            .goMenuUpdate(foodtruckmenuidmap);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: const Color.fromARGB(
                                          255, 175, 175, 175),
                                      onPressed: () {
                                        controller.goMenuDelete(
                                            select, menu['menu_id']);
                                      },
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('가격: ${menu['menu_price']}'),
                                  Text('설명: ${menu['menu_description']}'),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewTab(BuildContext context, String select, String uid,
      String writeuid, Size size, FoodtruckdetailController controller) {
    final Map<String, dynamic> foodtruckidmap = {'foodtruck_id': select};
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (uid == writeuid) ...[
            ElevatedButton(
              onPressed: () {
                controller.goReviewSetting(foodtruckidmap);
              },
              child: const Text('리뷰 추가'),
            ),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: Obx(
              () {
                if (controller.reviewList.isEmpty) {
                  return const Center(child: Text('등록된 리뷰가 없습니다.'));
                } else {
                  return ListView.builder(
                    itemCount: controller.reviewList.length,
                    itemBuilder: (context, index) {
                      final review = controller.reviewList[index];
                      final Map<String, dynamic> foodtruckreviewidmap = {
                        'foodtruck_id': select,
                        'review_id': review['review_id']
                      };
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: Image.network(
                                    review['user_img'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBarIndicator(
                                    rating: review['Rating'],
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  if (uid == review['user_uid']) ...[
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: const Color.fromARGB(
                                              255, 175, 175, 175),
                                          onPressed: () {
                                            controller.goReviewUpdate(
                                                foodtruckreviewidmap);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: const Color.fromARGB(
                                              255, 175, 175, 175),
                                          onPressed: () {
                                            controller.goReviewDelete(
                                                select, review['review_id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${review['user_name']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('${review['review_create_date']}'),
                                    ],
                                  ),
                                  if (review['update'] == 1)
                                    const Text(
                                      '(수정됨)',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(review['review_context']),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  );
                }
              },
            ),
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
