import 'package:flutter/material.dart';
import 'package:food_truck/controller/profilesetting_controller.dart';
import 'package:get/get.dart';
import '../style/font_style.dart';

class ProfilesettingView extends GetView<ProfilesettingController> {
  const ProfilesettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      user['user_img'],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['user_name'], style: CustomTextStyles.title),
                      Text(user['user_email'],
                          style: CustomTextStyles.captionsubtitle),
                    ],
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
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: '닉네임 입력',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                // 수정하기 버튼이 클릭되었을 때의 동작
                                print(user);
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
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        const Text('이메일', style: CustomTextStyles.bodyBold),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: '이메일 입력',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                // 수정하기 버튼이 클릭되었을 때의 동작
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
