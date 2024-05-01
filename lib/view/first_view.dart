import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyView(),
    );
  }
}

class MyView extends StatelessWidget {
  const MyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('White Screen'),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
