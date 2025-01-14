import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruck_controller.dart';
//import 'package:food_truck/controller/myfoodtruck_controller.dart';
import 'package:get/get.dart';
import 'package:food_truck/controller/profile_controller.dart';
import '../style/font_style.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      controller.goToLogin();
    }
    String uid = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
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
                                      controller.goToReviewPage();
                                    },
                                    icon: const Icon(Icons.rate_review),
                                    label: const Text('내 리뷰',
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
                                  controller
                                      .goToProfilesettingPage(snapshot.data);
                                },
                                child: Container(
                                    color: Colors.white70,
                                    child: const Row(
                                      children: [
                                        Text('나의 정보 수정',
                                            style: CustomTextStyles.body),
                                        Spacer(),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    )),
                              ),
                              const SizedBox(height: 16.0),
                              const Divider(height: 1.0, color: Colors.grey),
                              const SizedBox(height: 16.0),

                              // 판매자용 섹션 조건부 렌더링
                              Obx(() {
                                if (controller.userType.value == 1) {
                                  return Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text('판매자용',
                                              style: CustomTextStyles.bodyBold),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      GestureDetector(
                                        onTap: () {
                                          controller.goToFoodtruckcreatePage(
                                              snapshot.data);
                                        },
                                        child: Container(
                                          color: Colors.white70,
                                          child: const Row(
                                            children: [
                                              Text('푸드트럭 생성하기',
                                                  style: CustomTextStyles.body),
                                              Spacer(),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Divider(
                                          height: 1.0, color: Colors.grey),
                                      const SizedBox(height: 16.0),
                                      GestureDetector(
                                        onTap: () {
                                          controller.goToMyFoodtruck();
                                        },
                                        child: Container(
                                          color: Colors.white70,
                                          child: const Row(
                                            children: [
                                              Text('나의 푸드트럭',
                                                  style: CustomTextStyles.body),
                                              Spacer(),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Divider(
                                          height: 1.0, color: Colors.grey),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                              const SizedBox(height: 16.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('경고'),
                                              content:
                                                  const Text('정말 로그아웃 하시겠습니까?'),
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
                                                    Navigator.of(context).pop();
                                                    controller
                                                        .signOutWithGoogle();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        '로그아웃',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors
                                              .blue, // 클릭 가능하게 보이도록 텍스트 색상 변경
                                          decoration:
                                              TextDecoration.underline, // 밑줄 추가
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 16.0), // 로그아웃과 탈퇴하기 간의 간격
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('경고'),
                                              content:
                                                  const Text('정말 탈퇴 하시겠습니까?'),
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
                                                    Navigator.of(context).pop();
                                                    controller.userDelete();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        '탈퇴하기',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors
                                              .red, // 클릭 가능하게 보이도록 텍스트 색상 변경
                                          decoration:
                                              TextDecoration.underline, // 밑줄 추가
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
