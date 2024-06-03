import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/favorite_model.dart';

class FavoriteController {
  final FavoriteModel _favoriteModel = FavoriteModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> favoriteTruckInsert(String foodtruckid) async {
    User user = _auth.currentUser!;
    _favoriteModel.favoriteFoodTruckCreate(foodtruckid, user.uid);
  }

  Future<void> favoriteFoodTruckDelete(String foodtruckid, String uid) async {
    return _favoriteModel.favoriteFoodTruckDelete(foodtruckid, uid);
  }
}
