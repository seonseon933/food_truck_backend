import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/oldcontroller/logincontroller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _authController = LoginController();
  late User curruntUser;
  final LoginController _loginController = LoginController();
  String? name = "";
  String? email = "";
  String? url = "";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (email == null || email!.isEmpty)
                ElevatedButton(
                  // images/icon에 googleLogin.jpg 있음! 이미지 사용하기.
                  child: const Text('로그인'),
                  onPressed: () async {
                    final user = await _authController.signInWithGoogle();
                    if (user != null) {
                      // setState()의 코드 : 확인 차 존재하는 코드로, 삭제하여도 문제 없음.
                      setState(() {
                        email = user.email;
                        url = user.photoURL;
                        name = user.displayName;
                      });

                      // 로그인을 한 후 checktype에 값을 받아 만약 user_type이 안 정해져 있다면(최초로그인이라면(checktype이 true))
                      // 사용자 타입 받는 페이지로 이동하고, radiobutton 사용하는 코드 작성 후 아래의 .saveUserType(~) 코드를 작성해 타입 저장하게 후 지도(메인)페이지로.
                      // 만약 user_type이 정해져있다면(checktype이 false) 바로 지도(메인)페이지로 이동.

                      int checktype = await _loginController.checkUserType();

                      // 정해져있지 않으면(true)
                      if (checktype == 1) {
                        // radio button
                        _loginController.saveUserType("판매자");
                      }
                      // checktype == -1 <- 에러남.
                    }
                  },
                )
              else // 여기는 확인 차 존재하는 코드로, 삭제하여도 문제 없음.
                Column(
                  children: <Widget>[
                    Image.network(url!),
                    Text(name!),
                    Text(email!),
                    // 로그아웃
                    ElevatedButton(
                      onPressed: () {
                        _authController.signOutWithGoogle();
                        setState(() {
                          email = "";
                          url = "";
                          name = "";
                        });
                      },
                      child: const Text('로그아웃'),
                    ),
                    // 탈퇴
                    ElevatedButton(
                        onPressed: () {
                          _authController.userDelete();
                        },
                        child: const Text('탈퇴하기'))
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
