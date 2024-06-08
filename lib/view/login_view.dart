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
              Colors.white,
              Colors.white,
            ],
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
                'assets/login/foodtruck_icon.png',
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
