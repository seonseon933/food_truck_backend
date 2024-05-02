import 'package:flutter/material.dart';
import 'package:food_truck/view/first_view.dart';
import 'package:food_truck/api/naver_map_api.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapApp.init();
  runApp(const NaverMapApp());
}