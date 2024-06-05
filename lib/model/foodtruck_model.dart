import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FoodTruckModel {
  late String uid;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _store = FirebaseFirestore.instance;
  final String defaultImg =
      "https://firebasestorage.googleapis.com/v0/b/food-truck-19f2d.appspot.com/o/defaultimg.jpg?alt=media&token=ea4a0bef-c962-49c9-a8ef-c20f9e2ecada";

  Future<String> createFoodTruck(
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File? file,
      String truckTag,
      String uid,
      double trucklatitude,
      double trucklongitude) async {
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
        'truck_avgrating': 0,
        'truck_latitude': trucklatitude,
        'truck_longitude': trucklongitude,
        'truck_review_ctn': 0 // 리뷰 개수
      };
      print(
          '위치 trucklatitude : $trucklatitude, trucklongitude : $trucklongitude');
      await docref.set(newFoodTruck);

      if (file != null) {
        await updateFoodTruckImg(docref.id, file);
      } else {
        await _store
            .collection('FoodTruck')
            .doc(docref.id)
            .update({'truck_img': defaultImg});
      }
      return docref.id;
    } catch (e) {
      print('푸드트럭 등록 : $e');
    }
    return '';
  }

  Future<String> updateFoodTruck(
      String foodtruckid,
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      Map<String, dynamic> paymentOptions,
      File? file,
      String truckTag,
      double latitude,
      double longitude) async {
    try {
      if (file != null) {
        await updateFoodTruckImg(foodtruckid, file); // await 추가함
      }
      await _store.collection('FoodTruck').doc(foodtruckid).update({
        'truck_name': truckName,
        'truck_phone': truckPhone,
        'truck_schedule': truckSchedule,
        'truck_description': truckDescription,
        'truck_tag': truckTag,
        'truck_payment': paymentOptions,
        'truck_latitude': latitude,
        'truck_longitude': longitude
      });

      return foodtruckid;
    } catch (e) {
      print('푸드트럭 수정 부분 에러 : $e');
      return '';
    }
  }

  Future<void> deleteFoodTruck(String foodtruckid) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _store.collection('FoodTruck').doc(foodtruckid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      await deleteFoodTruckImgStorage(data); // await 추가함
      await _store.collection('FoodTruck').doc(foodtruckid).delete();
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
        await deleteFoodTruckImgStorage(data); // await 추가함
      }

      final ref = _storage.ref(destination);
      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();
      await _store
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

  // 등록된 푸드트럭 전체 데이터 불러오기 - 현재 등록된 푸드트럭 전체 데이터 <- 푸드트럭 목록. => 상세
  Future<List<Map<String, dynamic>>> getFoodTruckData() async {
    try {
      QuerySnapshot querySnapshot = await _store.collection('FoodTruck').get();
      List<Map<String, dynamic>> foodtrucks = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        data['foodtruck_id'] = doc.id; // 문서 ID
        foodtrucks.add(data);
      }
      return foodtrucks;
    } catch (e) {
      print('푸드트럭 전체 데이터 불러오기 오류 : $e');
      return [];
    }
  }

  // 해당 푸드트럭 데이터 불러오기 - 상세 페이지
  Future<Map<String, dynamic>> getDetailFoodTruck(String foodtruckid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _store.collection('FoodTruck').doc(foodtruckid).get();
      Map<String, dynamic> foodtruckdata =
          documentSnapshot.data() as Map<String, dynamic>;
      foodtruckdata['foodtruck_id'] = foodtruckid;
      return foodtruckdata;
    } catch (e) {
      print('해당 문서ID 푸드트럭 데이터 불러오기 오류 : $e');
      return {};
    }
  }

  // 찜한 푸드트럭 불러오기
  Future<List<String>> getFavoriteFoodTruck(String uid) async {
    try {
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
    } catch (e) {
      print('찜한 푸드트럭 데이터 불러오기 에러 :$e');
      return [];
    }
  }

// 푸드트럭 태그를 기반으로 검색하는 함수 <- 푸드트럭 목록 페이지에 검색 기능 따로 넣어야 함. 지도 검색에 넣으면 겹쳐서 구현 어려움..
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
