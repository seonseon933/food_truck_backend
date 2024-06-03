import 'package:cloud_firestore/cloud_firestore.dart';

class TestMap {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> saveLocationToFirestore(
      double latitude, double longitude) async {
    try {
      await _store.collection('TestMap').doc('test222').set({
        'latitude': latitude,
        'longitude': longitude,
      });
      print('Location saved to Firestore');
    } catch (e) {
      print('위치 Firestore에 저장 실패 : $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLocationData() async {
    try {
      QuerySnapshot querySnapshot = await _store.collection('TestMap').get();
      List<Map<String, dynamic>> testmaps = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        data['testmap_id'] = doc.id;
        testmaps.add(data);
      }
      print('끼아아ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ아아앙ㅇㄴㅇㄺ : $testmaps');
      return testmaps;
    } catch (e) {
      print('가져올 수 없다능 : $e');
      return [];
    }
  }
}
