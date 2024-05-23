/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/firebase_options.dart';
import 'package:food_truck/view/homepage.dart';
import 'package:food_truck/view/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 얘는 라이브러리 사용할 때 사용하는 필수 코드.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var currentUser = FirebaseAuth.instance.currentUser;

  Widget homeWidget;
  if (currentUser != null) {
    homeWidget = const Homepage(); // 로그인을 한 적이 있는 경우 이동됨
  } else {
    homeWidget = const Login(); // 로그인을 한 적이 없는 기기면 이동됨.
  }
  runApp(MaterialApp(home: homeWidget));
}
*/

// 지도 api 테스트
import 'package:flutter/material.dart';

import 'package:food_truck/api/naver_map_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapApp.init();
  runApp(const NaverMapApp());
}
