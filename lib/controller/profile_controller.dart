import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/app_id.dart';
import 'package:food_truck/controller/base_controller.dart';
import 'package:food_truck/view/foodtruckcreatemap_view.dart';
import 'package:food_truck/view/myfoodtruck_view.dart';
import 'package:food_truck/view/profilesetting_view.dart';
//import 'package:food_truck/view/foodtrucksetting_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app_pages.dart';
//import '../view/setting_view.dart';
import '../view/profile_view.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _store = FirebaseFirestore.instance;
  var user = Rxn<Map<String, dynamic>>();
  String uid = "";

  void goToFoodtruckcreatePage() {
    Get.toNamed(
      Routes.FOODTRUCKCREATEMAP,
      id: profileD,
    );
  }

  void goToReviewPage() {
    Get.toNamed(Routes.REVIEW, id: profileD);
  }

  void goToFoodtrucksettingPage() {
    Get.toNamed(Routes.FOODTRUCKSETTING, id: profileD);
  }

  void goToMyFoodtruck() {
    Get.toNamed(Routes.MYFOODTRUCK, id: profileD);
  }

  void goToProfilesettingPage() {
    Get.toNamed(
      Routes.PROFILESETTING,
      id: profileD,
    );
  }

  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  getUserData(String userid) async {
    uid = userid;
    try {
      DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('사용자 정보 가져오기 오류 : $e ');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOutWithGoogle() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print("사용자 로그아웃 실패 : $e");
    }
  }
}

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // !important
      key: Get.nestedKey(profileD),
      initialRoute: Routes.PROFILE,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == Routes.PROFILE) {
          return GetPageRoute(
              routeName: Routes.PROFILE,
              page: () => const ProfileView(),
              binding: ProfileBinding());
        } else if (routeSettings.name == Routes.MYFOODTRUCK) {
          return GetPageRoute(
              routeName: Routes.MYFOODTRUCK,
              page: () => const MyFoodtruckView(),
              binding: MyFoodtruckBinding());
        } else if (routeSettings.name == Routes.PROFILESETTING) {
          return GetPageRoute(
              routeName: Routes.PROFILESETTING,
              page: () => const ProfilesettingView(),
              binding: ProfilesettingBinding());
        } else if (routeSettings.name == Routes.FOODTRUCKCREATEMAP) {
          return GetPageRoute(
              routeName: Routes.FOODTRUCKCREATEMAP,
              page: () => const FoodtruckcreatemapView(),
              binding: FoodtruckcreateBinding());
        }
        return null;
      },
    );
  }
}
