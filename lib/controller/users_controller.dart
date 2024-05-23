import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/usersmodel.dart';
import 'package:image_picker/image_picker.dart';

class UsersController {
  final UsersModel _usersModel = UsersModel();
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getUserImgGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    User? user = _auth.currentUser;

    if (image != null && user != null) {
      File file = File(image.path);
      _usersModel.updateUserImg(user, file);
    }
  }
}
