import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/usersmodel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/profile_controller.dart';

class ProfilesettingController extends GetxController {
  final UsersModel _usersModel = UsersModel();
  final _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileController profileController = Get.find<ProfileController>();
  final suser = Get.find<ProfileController>().user;

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    return _usersModel.getUserData(uid);
  }

  // 사용자 이름 변경 코드
  Future<void> updateUserName(String name) async {
    User cuser = _auth.currentUser!;
    await _usersModel.updateUserName(name, cuser.uid);

    suser.value = await getUserData(cuser.uid);
    profileController.user.value = suser.value;
    print(profileController.user.value);
  }

  // 갤러리에서 이미지 가져올 수 있도록.
  Future<void> getUserImgGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    User? cuser = _auth.currentUser;

    if (image != null && cuser != null) {
      File file = File(image.path);
      await _usersModel.updateUserImg(cuser, file);

      suser.value = await getUserData(cuser.uid);
      profileController.user.value = suser.value;
    }
  }

  void ImgChange() {
    print("프로필 이미지 변경기능 추가");
  }
}
