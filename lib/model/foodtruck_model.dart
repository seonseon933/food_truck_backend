import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FoodTruckModel {
  late String uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _store = FirebaseFirestore.instance;
  // 삭제 부분.....해야 함.
  // 트럭 주소, 위치 정보는 제외함. 지도 기능 다 구현이 되면 추가할 것임.
  Future<void> createFoodTruck(String truckName, String truckDescription,
      String truckSchedule, String truckPhone, File file) async {
    User user = _auth.currentUser!;
    uid = user.uid;
    String timenow = DateFormat("yyyy년 MM월 dd일").format(DateTime.now());

    Map<String, dynamic> newFoodTruck = {
      'user_uid': uid,
      'truck_name': truckName,
      'truck_create_date': timenow,
      'truck_phone': truckPhone,
      'truck_schedule': truckSchedule,
      'truck_description': truckDescription
    };

    DocumentReference docref = _store.collection('FoodTruck').doc();
    await docref.set(newFoodTruck);
    docref.collection('Menu'); // 서브 컬렉션 Menu!

    updateFoodTruckImg(docref.id, file);
  }

  // 푸드트럭 수정 코드(푸드트럭 문서ID 필요, File? file=null; 로 해주고 사용자가 이미지 변경했을 때 file에 값 넣어줌.)
  // file이 null인 것은 이미지 선택을 안 했다는 의미. 이 부분은 menu_model.dart의 updateMenu(+메뉴 문서ID 필요)도 동일.
  Future<void> updateFoodTruck(
      String foodtruckid,
      String truckName,
      String truckDescription,
      String truckSchedule,
      String truckPhone,
      File? file) async {
    User user = _auth.currentUser!;
    uid = user.uid;

    try {
      if (file != null) {
        updateFoodTruckImg(foodtruckid, file);
      }
      _store.collection('FoodTruck').doc(foodtruckid).update({
        'truck_name': truckName,
        'truck_phone': truckPhone,
        'truck_schedule': truckSchedule,
        'truck_description': truckDescription
      });
    } catch (e) {
      print('푸드트럭 수정 부분 에러 : $e');
    }
  }

  // 푸드트럭 삭제. 리뷰랑, 메뉴도 처리해줘야 함. <- fuctions 사용해야 함.
  Future<void> deleteFoodTruck(String foodtruckid) async {
    final DocumentSnapshot documentSnapshot =
        await _store.collection('FoodTruck').doc(foodtruckid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    deleteFoodTruckImgStorage(data, foodtruckid);
    _store.collection('FoodTruck').doc(foodtruckid).delete();
  }

  // 트럭 이미지 추가/변경
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
        deleteFoodTruckImgStorage(data, foodtruckid);
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
  Future<void> deleteFoodTruckImgStorage(
      Map<String, dynamic> data, String foodtruckid) async {
    String oldImgUrl = data['truck_img'];

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
