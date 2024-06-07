import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/api/naver_map_api.dart';
import 'package:food_truck/controller/foodtruckdetail_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'controller/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 얘는 라이브러리 사용할 때 사용하는 필수 코드.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NaverMapApp.init();
  var currentUser = FirebaseAuth.instance.currentUser;

  Get.put(FoodtruckdetailController()); // add

  String initialRoute;

  if (currentUser != null) {
    initialRoute = Routes.BASE; // 로그인한 적 있을 때.
  } else {
    initialRoute = Routes.LOGIN; // 로그인 정보 없을 때.
  }
  //initialRoute = Routes.LOGIN;
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    print('Initial Route: $initialRoute'); // 초기 경로 로그 출력
    return GetMaterialApp(
      title: "FFOODD",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute, // 초기 경로 설정
      getPages: AppPages.routes, // 라우트 설정
    );
  }
}


/* 극초반때 테스트하던거
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
/*
// 지도 api 테스트
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:food_truck/api/naver_map_api.dart';
import 'package:food_truck/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NaverMapApp.init();
  runApp(const NaverMapApp());
}
*/
