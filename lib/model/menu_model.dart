import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

// 실시간 리스너를 컨트롤러에서 사용해 특정 컬렉션의 데이터가 추가, 수정, 삭제될 때마다
// 실행하는 건 그렇게 효율적이진 않을 것 같음. 어차피 수정, 삭제될 때마다 단일 문서 읽어오는데. 리스너가 그걸 읽으면 다시 읽어오니까
// 추가, 수정, 삭제가 일어나지 않으면 기존에 읽어두었던 모든 문서 데이터를 넘길 수 있는 방법이 없나?
// 변경하지도 않았는데 페이지를 다시 로드할 때마다 문서들을 다시 모두 읽어야 하니까

class MenuModel {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final String defaultImg =
      "https://firebasestorage.googleapis.com/v0/b/food-truck-19f2d.appspot.com/o/defaultimg.jpg?alt=media&token=ea4a0bef-c962-49c9-a8ef-c20f9e2ecada";

  // 메뉴 전체 문서 데이터 불러오기
  Future<List<Map<String, dynamic>>> getFoodTruckMenuData(
      String foodtruckId) async {
    QuerySnapshot querySnapshot = await _store
        .collection('FoodTruck')
        .doc(foodtruckId)
        .collection('Menu')
        .get();
    List<Map<String, dynamic>> menus = [];
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // 문서 ID를 포함
      menus.add(data);
    }
    return menus;
  }

  Future<String> createMenu(String foodtruckid, String menuName,
      String menuPrice, String menuDescription, File? file) async {
    try {
      DocumentReference docref = _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Menu')
          .doc();

      Map<String, dynamic> newMenu = {
        'menu_name': menuName,
        'menu_price': menuPrice,
        'menu_description': menuDescription,
        'menu_img': file == null ? defaultImg : null
      };

      await docref.set(newMenu);

      if (file != null) {
        updateMenuImg(foodtruckid, docref.id, file);
      }
      return foodtruckid;
    } catch (e) {
      print('메뉴 등록 에러 : $e');
      return '';
    }
  }

  Future<String> updateMenu(String foodtruckid, String menuid, String menuName,
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
      return foodtruckid;
    } catch (e) {
      print('메뉴 수정 에러 : $e');
      return '';
    }
  }

  // 메뉴 삭제
  Future<String> deleteMenu(String foodtruckid, String menuid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _store.collection('FoodTruck').doc(foodtruckid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      deleteMenuImgStorage(data);
      await _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Menu')
          .doc(menuid)
          .delete();
      return foodtruckid;
    } catch (e) {
      print('메뉴 삭제 오류 : $e');
      return '';
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
        deleteMenuImgStorage(data);
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
  Future<void> deleteMenuImgStorage(Map<String, dynamic> data) async {
    String oldImgUrl = data['menu_img'];

    try {
      String filePath = Uri.parse(oldImgUrl).path;
      filePath = filePath.substring(filePath.indexOf('/o/') + 3);
      filePath = Uri.decodeFull(filePath.split('?').first);

      if (filePath != "defaultimg.jpg") {
        await _storage.ref(filePath).delete();
      }
    } catch (e) {
      print('이미지 삭제 오류 $e');
    }
  }
}
