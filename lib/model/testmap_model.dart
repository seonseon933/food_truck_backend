import 'package:cloud_firestore/cloud_firestore.dart';

class TestMap {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> saveLocationToFirestore(
      double latitude, double longitude) async {
    try {
      await _store.collection('TestMap').doc('test').set({
        'latitude': latitude,
        'longitude': longitude,
      });
      print('Location saved to Firestore');
    } catch (e) {
      print('위치 Firestore에 저장 실패 : $e');
    }
  }
}
