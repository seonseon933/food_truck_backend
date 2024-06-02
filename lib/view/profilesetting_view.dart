import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_truck/controller/profilesetting_controller.dart';
import '../style/font_style.dart';

class ProfilesettingView extends GetView<ProfilesettingController> {
  const ProfilesettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setting'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                var user = controller.suser.value!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            user['user_img'] ?? '',
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['user_name'] ?? '',
                                style: CustomTextStyles.title),
                            Text(user['user_email'] ?? '',
                                style: CustomTextStyles.captionsubtitle),
                          ],
                        ),
                      ],
                    ),
                    // 나머지 위젯들
                  ],
                );
              }),
              Row(
                children: [
                  SizedBox(
                    width: 65, // 원하는 너비로 설정
                    height: 30, // 원하는 높이로 설정
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.getUserImgGallery();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 5), // 패딩 설정
                        minimumSize: const Size(30, 20), // 최소 크기 설정
                      ),
                      child: const Text(
                        '사진 변경',
                        style: TextStyle(fontSize: 10), // 글씨 크기 설정
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        const Text('닉네임', style: CustomTextStyles.bodyBold),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: TextField(
                                controller: TextEditingController(
                                    text: controller.suser.value!['user_name']),
                                onChanged: (value) {
                                  controller.suser.value!['user_name'] = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: '닉네임 입력',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                controller.updateUserName(
                                    controller.suser.value!['user_name']);
                              },
                              child: const Text('수정하기'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
