import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final _store = FirebaseFirestore.instance;
  Future<void> favoriteFoodTruckCreate(String foodtruckid, String uid) async {
    try {
      await _store.collection('Users').doc(uid).update({
        'favorite_truckid': FieldValue.arrayUnion([foodtruckid])
      });
    } catch (e) {
      print('찜 등록 에러 : $e');
    }
  }

  Future<void> favoriteFoodTruckDelete(String foodtruckid, String uid) async {
    try {
      await _store.collection('Users').doc(uid).update({
        'favorite_truckid': FieldValue.arrayRemove([foodtruckid])
      });
    } catch (e) {
      print('찜 삭제 에러 : $e');
    }
  }
}
