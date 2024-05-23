import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
// login_~, users_~ 컨트롤러에서 호출하는 model임.

class UsersModel {
  final _store = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(User user) async {
    try {
      uid = user.uid;
      String? email = user.email;
      String? name = user.displayName;
      String? img = user.photoURL;
      String imgSource = "google";

      final DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();

      if (!documentSnapshot.exists) {
        // 여기에, 구글계정의 프로필 사진의 경로 img에 timestamp를 붙여서 strage에 저장 후, 그 url을 user_img에 저장.
        await _store.collection("Users").doc(uid).set({
          'user_email': email,
          'user_img': img,
          'user_name': name,
          'user_img_source': imgSource,
          'review_create_truckid': [], // 푸드트럭의 리뷰를 작성하면, 해당 푸드트럭의 문서ID 저장.
          'favorite_truckid': [],
        });
      }

      return;
    } catch (e) {
      print('사용자 데이터 저장 실패 : $e');
    }
  }

  Future<void> deleteUserData() async {
    User user = _auth.currentUser!;
    uid = user.uid;

    await deleteUserImgStorage(uid);

    _store.collection("Users").doc(uid).delete().then(
          (doc) => print("탈퇴하고 사용자 정보 지워짐"),
          onError: (e) => print("사용자 정보 삭제에 문제가 생김"),
        );
  }

  // 사용자 회원 타입 존재 체크
  Future<int> checkUserType(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();

      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('user_type')) {
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      print('유저 타입 존재 체크 오류 : $e');
      return -1;
    }
  }

  // 사용자 회원 타입 저장
  Future<void> saveUserType(String type, String uid) async {
    try {
      _store.collection("Users").doc(uid).update({'user_type': type});
    } catch (e) {
      print('타입 저장 오류 : $e');
    }
  }

  //=================여기부터 users_controller.dart에서 호출==============

  // 사용자 닉네임 변경 코드
  Future<void> updateUserName(String name, String uid) async {
    try {
      _store.collection('Users').doc(uid).update({'user_name': name});
    } catch (e) {
      print('사용자 닉네임 변경 오류 : $e');
    }
  }

  // 사용자 프로필 사진 변경
  Future<void> updateUserImg(User user, File file) async {
    uid = user.uid;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = basename(file.path);
    String destination = "UsersImg/${timestamp}_$fileName";

    try {
      await deleteUserImgStorage(uid);
      // storage에 파일 업로드.
      final ref = _storage.ref(destination);
      await ref.putFile(file);

      // URL 가져오기
      String downloadURL = await ref.getDownloadURL();
      // store에 저장
      _store.collection('Users').doc(uid).update({'user_img': downloadURL});
    } catch (e) {
      print('이미지 저장 오류 $e');
    }
  }

  // 기존 프로필 사진 삭제
  Future<void> deleteUserImgStorage(String uid) async {
    final DocumentSnapshot documentSnapshot =
        await _store.collection('Users').doc(uid).get();

    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>;
    String imgSource = data['user_img_source'];
    String oldImgUrl = data['user_img'];

    if (imgSource == "storage") {
      try {
        String filePath = Uri.parse(oldImgUrl).path;
        filePath = filePath.substring(filePath.indexOf('/o/') + 3);
        filePath = Uri.decodeFull(filePath.split('?').first);
        await _storage.ref(filePath).delete();
      } catch (e) {
        print('storage에 있는 이미지 삭제 실패 : $e');
      }
    } else {
      _store
          .collection("Users")
          .doc(uid)
          .update({'user_img_source': "storage"});
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('사용자 정보 가져오기 오류 : $e ');
      return null;
    }
  }

  Future<int> getUserType(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data['user_img'] == '판매자') {
          return 1; // 판매자
        } else {
          return 0; // 구매자
        }
      }
      return -1;
    } catch (e) {
      print('타입 가져오기 오류 : $e');
      return -1;
    }
  }
}
