import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReviewModel {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  late String uid;

  // 해당 푸드트럭의 리뷰 전체 문서 데이터 불러오기
  Future<List<Map<String, dynamic>>> getFoodTruckReviewsData(
      String foodtruckId) async {
    try {
      QuerySnapshot querySnapshot = await _store
          .collection('FoodTruck')
          .doc(foodtruckId)
          .collection('Review')
          .get();
      List<Map<String, dynamic>> review = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        data['review_id'] = doc.id; // 문서 ID를 포함
        review.add(data);
      }
      return review;
    } catch (e) {
      print('해당 푸드트럭의 리뷰 데이터 불러오기 오류 : $e');
      return [];
    }
  }

  // 해당 사용자가 작성한 푸드트럭 리뷰 문서 데이터 불러오기
  Future<List<Map<String, dynamic>>> getUserReviewsData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<String> truckIDs =
          List<String>.from(userData['review_create_truckid'] ?? []);

      List<Map<String, dynamic>> userReviews = [];

      // 각 푸드트럭 문서 존재 여부를 병렬로 확인
      List<Future<void>> futures = truckIDs.map((truckId) async {
        DocumentSnapshot truckSnapshot =
            await _store.collection('FoodTruck').doc(truckId).get();

        if (!truckSnapshot.exists) {
          await _store.collection('Users').doc(uid).update({
            'review_create_truckid': FieldValue.arrayRemove([truckId])
          });
          return;
        }

        Map<String, dynamic> truckData =
            truckSnapshot.data() as Map<String, dynamic>;
        String truckName = truckData['truck_name'];

        QuerySnapshot reviewSnapshot = await _store
            .collection('FoodTruck')
            .doc(truckId)
            .collection('Review')
            .where('user_uid', isEqualTo: uid)
            .get();

        for (var reviewDoc in reviewSnapshot.docs) {
          Map<String, dynamic> reviewData =
              reviewDoc.data() as Map<String, dynamic>;

          userReviews.add({
            'truck_id': truckId,
            'truck_name': truckName,
            'review_id': reviewDoc.id,
            'review_context': reviewData['review_context'],
            'Rating': reviewData['Rating']
          });
        }
      }).toList();

      // 모든 비동기 작업 완료 대기
      await Future.wait(futures);

      return userReviews;
    } catch (e) {
      print('해당 사용자가 작성한 리뷰 목록 불러오기 오류 : $e');
      return [];
    }
  }

  Future<String> createReview(String foodtruckid, String uid, double rating,
      String reviewContext) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _store.collection('Users').doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      String timenow = DateFormat("yyyy년 MM월 dd일").format(DateTime.now());

      Map<String, dynamic> newReview = {
        'review_create_date': timenow,
        'user_uid': uid,
        'user_name': data['user_name'],
        'user_img': data['user_img'],
        'Rating': rating,
        'review_context': reviewContext,
        'update': 0,
      };

      DocumentReference docref = _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Review')
          .doc();
      await docref.set(newReview);

      _store.collection('Users').doc(uid).update({
        'review_create_truckid': FieldValue.arrayUnion([foodtruckid]) // 중복X
      });

      await updateAvgRating(foodtruckid);

      return foodtruckid;
    } catch (e) {
      print('리뷰 등록 에러 : $e');
      return foodtruckid;
    }
  }

  Future<String> updateReview(String foodtruckid, String reviewid,
      double rating, String reviewContext) async {
    String timenow = DateFormat("yyyy년 MM월 dd일").format(DateTime.now());
    try {
      await _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Review')
          .doc(reviewid)
          .update({
        'review_create_date': timenow,
        'Rating': rating,
        'review_context': reviewContext,
        'update': 1,
      });

      await updateAvgRating(foodtruckid);

      return foodtruckid;
    } catch (e) {
      print('리뷰 수정 에러 : $e');
      return foodtruckid;
    }
  }

  Future<String> deleteReview(
      String foodtruckid, String reviewid, String uid) async {
    try {
      await _store
          .collection('FoodTruck')
          .doc(foodtruckid)
          .collection('Review')
          .doc(reviewid)
          .delete();
      await _store.collection('Users').doc(uid).update({
        'review_create_truckid': FieldValue.arrayRemove([foodtruckid])
      });

      await updateAvgRating(foodtruckid);

      return foodtruckid;
    } catch (e) {
      print('리뷰 삭제 오류 : $e');
      return foodtruckid;
    }
  }

  // 평균평점 계산
  Future<void> updateAvgRating(String foodtruckId) async {
    try {
      QuerySnapshot reviewSnapshot = await _store
          .collection('FoodTruck')
          .doc(foodtruckId)
          .collection('Review')
          .get();
      // 리뷰 존재
      if (reviewSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in reviewSnapshot.docs) {
          totalRating += doc['Rating'];
        }
        double averageRating = totalRating / reviewSnapshot.docs.length;

        // 푸드트럭 문서에 평균 평점 업데이트
        await _store
            .collection('FoodTruck')
            .doc(foodtruckId)
            .update({'truck_avgrating': averageRating});
      }
      // 리뷰 없음
      else {
        await _store
            .collection('FoodTruck')
            .doc(foodtruckId)
            .update({'truck_avgrating': 0});
      }
    } catch (e) {
      print('푸드트럭 평균 평점 에러 : $e ');
    }
  }
}
