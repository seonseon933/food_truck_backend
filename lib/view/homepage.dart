import 'package:flutter/material.dart';
import 'package:food_truck/controller/logincontroller.dart';
import 'package:food_truck/controller/users_controller.dart';
import 'package:food_truck/view/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Homepage> {
  final LoginController _authController = LoginController();
  final UsersController _usersController = UsersController();

  @override
  Widget build(BuildContext context) {
    return Placeholder(
        child: Scaffold(
            body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              await _authController.signOutWithGoogle();
              Navigator.push(
                // 로그인 페이지로 다시 이동.
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text('로그아웃'),
          ),
          ElevatedButton(
              onPressed: () {
                _authController.userDelete();
                Navigator.push(
                  // 로그인 페이지로 다시 이동.
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text('탈퇴하기')),
          // 닉네임 변경은 view에선 안 만듦.
          ElevatedButton(
              onPressed: () async {
                await _usersController.getUserImgGallery();
              },
              child: const Text('프로필 사진 변경'))
        ],
      ),
    )));
  }
}
