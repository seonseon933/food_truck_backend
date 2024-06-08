import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/style/font_style.dart';
import 'package:get/get.dart';

class FoodtruckView extends GetView<FoodtruckController> {
  const FoodtruckView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    controller.ObsgetFoodTruckData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodtruck'),
      ),
      body: Obx(() {
        if (controller.foodTrucks.isEmpty) {
          return const Center(
            child: Text('등록된 푸드트럭이 없습니다.'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: controller.foodTrucks.length,
              itemBuilder: (context, index) {
                final foodtruck = controller.foodTrucks[index];
                return GestureDetector(
                  onTap: () {
                    Map<String, dynamic> mapfoodtruck = {
                      'foodtruck_id': foodtruck['foodtruck_id']
                    };
                    controller.goDetail(mapfoodtruck);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                            image: NetworkImage(foodtruck['truck_img']),
                            width: size.width * 0.3,
                            height: size.height * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  foodtruck['truck_name'],
                                  style: CustomTextStyles.bodyBold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.yellow, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    foodtruck['truck_avgrating'].toString(),
                                    style: CustomTextStyles.body,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "(${foodtruck['truck_review_ctn']?.toString() ?? '0'})",
                                    style: CustomTextStyles.body,
                                  ),
                                ],
                              ),
                              Text(
                                '${foodtruck['truck_tag']}\n 운영시간: ${foodtruck['truck_schedule']}',
                                style: CustomTextStyles.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
