import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:food_truck/controller/profile_controller.dart';
import '../style/font_style.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      controller.goToLogin();
    }
    String uid = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                FutureBuilder(
                    future: (controller.getUserData(uid)),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      snapshot.data['user_img'],
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          snapshot.data['user_name'].toString(),
                                          style: CustomTextStyles.title),
                                      Text(
                                          snapshot.data['user_email']
                                              .toString(),
                                          style:
                                              CustomTextStyles.captionsubtitle),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(height: 50.0),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // 내 리뷰로 이동하는 기능 추가
                                      //controller.goToReviewPage();
                                    },
                                    icon: const Icon(Icons.rate_review),
                                    label: const Text('내 리뷰',
                                        style: CustomTextStyles.body),
                                  ),
                                  const SizedBox(width: 8.0),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // 알림함으로 이동하는 기능 추가
                                    },
                                    icon: const Icon(Icons.notifications),
                                    label: const Text('알림함',
                                        style: CustomTextStyles.body),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              const Divider(height: 1.0, color: Colors.grey),
                              const SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () {},
                                child: const Row(
                                  children: [
                                    Text('회원정보수정',
                                        style: CustomTextStyles.bodyBold),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('경고'),
                                        content: const Text(
                                            '회원 정보 수정 페이지로 이동하시겠습니까?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('아니오'),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('예'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 팝업 창 닫기
                                              controller.goToProfilesettingPage(
                                                  snapshot.data);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text('나의 정보 수정',
                                        style: CustomTextStyles.body),
                                    Spacer(),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              const Divider(height: 1.0, color: Colors.grey),
                              const SizedBox(height: 16.0),
                              const Row(
                                children: [
                                  Text('판매자용',
                                      style: CustomTextStyles.bodyBold),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('경고'),
                                        content: const Text(
                                            '푸드트럭 생성 페이지로 이동하시겠습니까?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('아니오'),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('예'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 팝업 창 닫기
                                              controller
                                                  .goToFoodtruckcreatePage(
                                                      snapshot.data);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text('푸드트럭 생성하기',
                                        style: CustomTextStyles.body),
                                    Spacer(),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              const Divider(height: 1.0, color: Colors.grey),
                              const SizedBox(height: 16.0),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('경고'),
                                        content: const Text(
                                            '푸드트럭 정보 수정 페이지로 이동하시겠습니까?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('아니오'),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('예'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 팝업 창 닫기
                                              //controller
                                              //    .goToFoodtrucksettingPage();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text('푸드트럭 정보수정',
                                        style: CustomTextStyles.body),
                                    Spacer(),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              const Divider(height: 1.0, color: Colors.grey),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        );
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
