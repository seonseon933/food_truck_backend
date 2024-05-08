import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/logincontroller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // food-truck-19z 프젝 적용
  final LoginController _authController = LoginController();
  late User curruntUser;
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
                      setState(() {
                        email = user.email;
                        url = user.photoURL;
                        name = user.displayName;
                      });
                      debugPrint('로그인됐고, email,url등 다 들어감'); // 나중에 삭제 예정
                    }
                  },
                )
              else
                Column(
                  children: <Widget>[
                    Image.network(url!),
                    Text(name!),
                    Text(email!),
                    ElevatedButton(
                      child: const Text('로그아웃'),
                      onPressed: () {
                        _authController.signOutWithGoogle();
                        setState(() {
                          email = "";
                          url = "";
                          name = "";
                        });
                      },
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
