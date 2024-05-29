import 'package:flutter/material.dart';
import 'package:food_truck/getcontroller/login_controller.dart';
import '../getcontroller/app_pages.dart';
import '../style/font_style.dart';
import 'package:get/get.dart';

class FirstLogin extends StatelessWidget {
  const FirstLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController getxlogincontroller = LoginController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey, // 조금 더 진한 파스텔 핑크색
              Colors.white,
              Colors.grey, // 조금 더 진한 파스텔 주황색
            ],
            begin: Alignment.topCenter, // 그라데이션 시작 위치 설정
            end: Alignment.bottomCenter, // 그라데이션 종료 위치 설정
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('최초 로그인 구분', style: CustomTextStyles.title),
              TextButton(
                child: const Text('판매자인가요?'),
                onPressed: () {
                  getxlogincontroller.saveUserType("판매자");
                  Get.offNamed(Routes.HOME);
                  getxlogincontroller.goBase(); // 테스트 못해봄
                },
              ),
              TextButton(
                child: const Text('소비자인가요?'),
                onPressed: () {
                  getxlogincontroller.saveUserType("소비자");
                  getxlogincontroller.goBase();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
