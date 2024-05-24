import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

// 검색 기능 만들어야 함. -> 해시태그, 푸드트럭명으로 하면 되겠다.
// 실시간 리스너 알아보기..

class FoodTruckModel {
  late String uid;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _store = FirebaseFirestore.instance;
  final String defaultImg =
      "https://firebasestorage.googleapis.com/v0/b/food-truck-19f2d.appspot.com/o/defaultimg.jpg?alt=media&token=ea4a0bef-c962-49c9-a8ef-c20f9e2ecada";

  // 트럭 주소, 위치 정보는 제외함. 지도 기능 다 구현이 되면 추가할 것임.
  Future<String> createFoodTruck(
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File? file,
      String truckTag,
      String uid) async {
    String timenow = DateFormat("yyyy년 MM월 dd일").format(DateTime.now());
    DocumentReference docref = _store.collection('FoodTruck').doc();

    try {
      Map<String, dynamic> newFoodTruck = {
        'user_uid': uid,
        'truck_name': truckName,
        'truck_create_date': timenow,
        'truck_phone': truckPhone,
        'truck_schedule': truckSchedule,
        'truck_tag': truckTag,
        'truck_description': truckDescription,
        'truck_payment': paymentOptions,
        'truck_img': file == null ? defaultImg : null,
        'truck_avgrating': 0
        //'truck_latitude' : 경도
        //'truck_longitude' : 위도
      };

      await docref.set(newFoodTruck);

      if (file != null) {
        updateFoodTruckImg(docref.id, file);
      }
      return docref.id;
    } catch (e) {
      print('푸드트럭 등록 : $e');
    }
    return '';
  }

  // 수정할 때 기존에 입력된 데이터 꺼내와서 넣어줘야 함. 입력값이 많으니 그렇게 하는게 좋음.
  Future<String> updateFoodTruck(
      String foodtruckid,
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File? file,
      String truckTag,
      String uid) async {
    try {
      if (file != null) {
        updateFoodTruckImg(foodtruckid, file);
      }
      _store.collection('FoodTruck').doc(foodtruckid).update({
        'truck_name': truckName,
        'truck_phone': truckPhone,
        'truck_schedule': truckSchedule,
        'truck_description': truckDescription,
        'truck_tag': truckTag,
        'truck_payment': paymentOptions,
      });
      return foodtruckid;
    } catch (e) {
      print('푸드트럭 수정 부분 에러 : $e');
      return '';
    }
  }

  // 푸드트럭 삭제. 리뷰랑, 메뉴도 처리해줘야 함. <- fuctions 사용해야 함.
  Future<void> deleteFoodTruck(String foodtruckid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _store.collection('FoodTruck').doc(foodtruckid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      deleteFoodTruckImgStorage(data);
      _store.collection('FoodTruck').doc(foodtruckid).delete();
    } catch (e) {
      print('푸드트럭 삭제 오류 : $e');
    }
  }

  // 트럭 이미지 변경
  Future<void> updateFoodTruckImg(String foodtruckid, File file) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName = basename(file.path);
    String destination = "FoodTruckImg/${timestamp}_$fileName";

    try {
      final DocumentSnapshot documentSnapshot =
          await _store.collection('FoodTruck').doc(foodtruckid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (documentSnapshot.exists &&
          documentSnapshot.data() != null &&
          data.containsKey('truck_img')) {
        deleteFoodTruckImgStorage(data);
      }

      final ref = _storage.ref(destination);
      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();
      _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .update({'truck_img': downloadUrl});
    } catch (e) {
      print('이미지 저장 오류 $e');
    }
  }

  // 기존에 저장된 트럭 이미지 삭제
  Future<void> deleteFoodTruckImgStorage(Map<String, dynamic> data) async {
    String oldImgUrl = data['truck_img'];

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

  // 찜한 푸드트럭 불러오기
  Future<List<String>> getFavoriteFoodTruck(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _store.collection('Users').doc(uid).get();
    List<String> favoriteTrucks = [];

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('favorite_truckid')) {
        favoriteTrucks = List<String>.from(data['favorite_truckid']);
      }
    }

    return favoriteTrucks;
  }

// 푸드트럭 태그를 기반으로 검색하는 함수
  Future<List<Map<String, String>>> searchFoodTrucksByTag(String tag) async {
    try {
      // Firestore에서 `truck_tag`가 입력된 `tag`와 정확히 일치하는 문서들을 가져오고ㅓ
      QuerySnapshot querySnapshot = await _store
          .collection('FoodTruck')
          .where('truck_tag', isEqualTo: tag)
          .get();

      List<Map<String, String>> matchingTrucks = [];

      for (var doc in querySnapshot.docs) {
        matchingTrucks.add({
          'truck_id': doc.id,
          'truck_name': doc['truck_name'],
        });
      }

      return matchingTrucks;
    } catch (e) {
      print('태그로 검색 오류 : $e');
      return [];
    }
  }
}
