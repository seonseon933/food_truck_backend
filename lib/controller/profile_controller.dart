import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_truck/controller/app_id.dart';
import 'package:food_truck/controller/base_controller.dart';
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
  late String uid;
  var user = Rxn<Map<String, dynamic>>();

  void goToSettingPage() {
    Get.toNamed(Routes.SETTING, id: profileD);
  }

  void goToReviewPage() {
    Get.toNamed(Routes.REVIEW, id: profileD);
  }

  void goToFoodtrucksettingPage() {
    Get.toNamed(Routes.FOODTRUCKSETTING, id: profileD);
  }

  void goToProfilesettingPage(Map<String, dynamic> userdata) {
    user.value = userdata;
    print(user);
    Get.toNamed(
      Routes.PROFILESETTING,
      id: profileD,
    );
  }

  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  getUserData(String uid) async {
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
        } /*else if (routeSettings.name == Routes.SETTING) {
          return GetPageRoute(
              routeName: Routes.SETTING,
              page: () => const SettingView(),
              binding: SettingBinding());
        }*/
        else if (routeSettings.name == Routes.PROFILESETTING) {
          return GetPageRoute(
              routeName: Routes.PROFILESETTING,
              page: () => const ProfilesettingView(),
              binding: ProfilesettingBinding());
        } /*else if (routeSettings.name == Routes.REVIEW) {
          return GetPageRoute(
              routeName: Routes.REVIEW,
              page: () => const Review(),
              binding: ReviewBinding());
        } else if (routeSettings.name == Routes.FOODTRUCKSETTING) {
          return GetPageRoute(
              routeName: Routes.FOODTRUCKSETTING,
              page: () => const FoodtrucksettingView(),
              binding: FoodtrucksettingBinding());
        }*/
        return null;
      },
    );
  }
}
