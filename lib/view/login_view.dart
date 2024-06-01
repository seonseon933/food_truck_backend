import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_truck/controller/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey,
              Colors.white, // 조금 더 진한 파스텔 핑크색
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
              const Text(
                'FFOODD   ',
                style: TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 106, 118, 124), // 텍스트 색상 검은색으로 변경
                ),
              ),
              Image.asset(
                'assets/images/foodtruck_icon.png', // 이미지 출처 : <a href="https://www.flaticon.com/kr/free-icons/-" title="- 아이콘">- 아이콘 제작자: iconixar - Flaticon</a>
                width: 200.0,
                height: 200.0,
              ),
              const SizedBox(height: 40.0),
              IconButton(
                onPressed: () {
                  LoginController().signInWithGoogle();
                },
                icon: SvgPicture.asset(
                  'assets/icons/android_light_rd_ctn.svg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
