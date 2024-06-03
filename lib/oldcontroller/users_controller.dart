import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/usersmodel.dart';
import 'package:image_picker/image_picker.dart';

class UsersController {
  final UsersModel _usersModel = UsersModel();
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 사용자 이름 변경 코드
  Future<void> updateUserName(String name) async {
    User user = _auth.currentUser!;
    _usersModel.updateUserName(name, user.uid);
  }

  // 갤러리에서 이미지 가져올 수 있도록.
  Future<void> getUserImgGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    User? user = _auth.currentUser;

    if (image != null && user != null) {
      File file = File(image.path);
      _usersModel.updateUserImg(user, file);
    }
  }

  // 사용자 타입 가져오기
  Future<int> getUserType() async {
    User user = _auth.currentUser!;
    return _usersModel.getUserType(user.uid);
  }

  // 마이페이지에 필요한 사용자 전체 정보
  Future<Map<String, dynamic>?> getUserData() async {
    User user = _auth.currentUser!;
    return _usersModel.getUserData(user.uid);
  }
}
