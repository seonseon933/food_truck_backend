import 'package:flutter/material.dart';
import 'package:food_truck/getcontroller/foodtruck_controller.dart'; // getcontroller
//import 'package:food_truck/controller/foodtruck_controller.dart';
import 'package:food_truck/style/font_style.dart';
import 'package:get/get.dart';

class FoodtruckView extends GetView<FoodtruckController> {
  const FoodtruckView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodtruck'),
      ),
      body: FutureBuilder(
          future: (controller.getFoodTruckData()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(fontSize: 15),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final foodtruck = snapshot.data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              image: NetworkImage(foodtruck['truck_img']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(foodtruck['truck_name'],
                              style: CustomTextStyles.bodyBold),
                          subtitle: Text(
                              '내용: ${foodtruck['truck_tag']}\n 평점: ${foodtruck['truck_avgrating']}',
                              style: CustomTextStyles.body),
                          onTap: () {
                            // controller.goDetail(foodtruck);
                            Map<String, dynamic> mapfoodtruck = {
                              'foodtruck_id': foodtruck['foodtruck_id']
                            };
                            controller.goDetail(mapfoodtruck);
                          },
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
