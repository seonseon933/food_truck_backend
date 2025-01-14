import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_truck/controller/reviewupdate_controller.dart';
import 'package:get/get.dart';

class ReviewupdateView extends GetView<ReviewupdateController> {
  const ReviewupdateView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = Get.arguments as Map;
    final foodtruckid = arguments['foodtruck_id'];
    final reviewid = arguments['review_id'];
    final Map<String, dynamic> foodtruck = {'foodtruck_id': foodtruckid};

    double rating = 0.0;
    final reviewController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 수정'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (ratingValue) {
                  rating = ratingValue;
                  print(rating); // This is where you capture the rating value
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '리뷰 내용 작성',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await controller.updateReview(
                      foodtruckid, reviewid, rating, reviewController.text);
                  controller.goDetail(foodtruck);
                },
                child: const Text('등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
