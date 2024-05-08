import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_truck/view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Login());
}
