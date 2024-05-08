import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersModel {
  final _storage = FirebaseFirestore.instance;
  Future<void> saveUserData(User user) async {
    try {
      String? uid = user.uid;
      String? email = user.email;
      String? name = user.displayName;
      String? img = user.photoURL;

      final DocumentSnapshot documentSnapshot =
          await _storage.collection('Users').doc(uid).get();

      if (!documentSnapshot.exists) {
        await _storage.collection("Users").doc(uid).set({
          'user_email': email,
          'user_img': img,
          'user_name': name,
        });
      }
      print('사용자 데이터 저장됨');

      return;
    } catch (e) {
      print('사용자 데이터 저장 실패 : $e');
    }
  }
}
