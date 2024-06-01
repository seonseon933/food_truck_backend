import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfilesettingController extends GetxController {
  final user = Get.find<ProfileController>().user;
  void ImgChange() {
    print("프로필 이미지 변경기능 추가");
  }
}
