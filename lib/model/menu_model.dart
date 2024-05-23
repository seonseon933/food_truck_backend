import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class MenuModel {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  // 메뉴 컬렉션은 FoodTruck의 서브 컬렉션임. 삭제하는게 난관 <- cloud function 사용해야 함.
  // 리뷰 컬렉션도 FoodTruck의 서브 컬렉션으로 만들어야 함.
  Future<void> createMenu(String foodtruckid, String menuName, String menuPrice,
      String menuDescription, File file) async {
    Map<String, dynamic> newMenu = {
      // 메뉴명, 가격, 소개, 메뉴 이미지(따로 추가)
      'menu_name': menuName,
      'menu_price': menuPrice,
      'menu_description': menuDescription
    };

    DocumentReference docref = _store
        .collection('FoodTruck')
        .doc(foodtruckid)
        .collection('Menu')
        .doc();
    await docref.set(newMenu);

    updateMenuImg(foodtruckid, docref.id, file);
  }

  Future<void> updateMenu(String foodtruckid, String menuid, String menuName,
      String menuPrice, String menuDescription, File? file) async {
    try {
      if (file != null) {
        updateMenuImg(foodtruckid, menuid, file);
      }
      _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Menu')
          .doc(menuid)
          .update({
        'menu_name': menuName,
        'menu_price': menuPrice,
        'menu_description': menuDescription
      });
    } catch (e) {
      print('메뉴 수정 에러 : $e');
    }
  }

  // 메뉴 이미지 추가/변경
  Future<void> updateMenuImg(
      String foodtruckid, String menuid, File file) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = basename(file.path);
    String destination = "MenuImg/${timestamp}_$fileName";

    try {
      final DocumentSnapshot documentSnapshot = await _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Menu')
          .doc(menuid)
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          data.containsKey('menu_img')) {
        deleteMenuImgStorage(data, foodtruckid, menuid);
      }

      final ref = _storage.ref(destination);
      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();
      _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Menu')
          .doc(menuid)
          .update({'menu_img': downloadUrl});
    } catch (e) {
      print('이미지 저장 오류 $e');
    }
  }

  // 기존에 저장된 메뉴 이미지 삭제
  Future<void> deleteMenuImgStorage(
      Map<String, dynamic> data, String foodtruckid, String menuid) async {
    String oldImgUrl = data['menu_img'];

    try {
      String filePath = Uri.parse(oldImgUrl).path;
      filePath = filePath.substring(filePath.indexOf('/o/') + 3);
      filePath = Uri.decodeFull(filePath.split('?').first);
      await _storage.ref(filePath).delete();
    } catch (e) {
      print('이미지 삭제 오류 $e');
    }
  }
}
