import 'package:flutter/material.dart';
import 'package:food_truck/controller/wishlist_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/base_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseController baseController = Get.find<BaseController>();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user!.uid;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WishlistView'),
        centerTitle: true,
      ),
      body: Obx(() {
        final favoriteTruckIds = baseController.favoriteTruckIds;
        if (favoriteTruckIds.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '찜 목록을 찾을수 없습니다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: favoriteTruckIds.length,
              itemBuilder: (context, index) {
                final foodTruckId = favoriteTruckIds[index];
                return FutureBuilder<Map<String, dynamic>?>(
                  future: controller.getFoodTruckData(uid, foodTruckId),
                  builder: (context, foodTruckSnapshot) {
                    if (foodTruckSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (foodTruckSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${foodTruckSnapshot.error}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    } else if (!foodTruckSnapshot.hasData ||
                        foodTruckSnapshot.data == null) {
                      return const SizedBox.shrink();
                    } else {
                      final foodtruck = foodTruckSnapshot.data!;
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
                                          foodtruck['truck_avgrating']
                                              .toString(),
                                          style: CustomTextStyles.body,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          "(리뷰개수)",
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
                    }
                  },
                );
              },
            ),
          );
        }
      }),
    );
  }
}
