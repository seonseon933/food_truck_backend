import 'dart:io';

import 'package:food_truck/model/menu_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'app_pages.dart';

class MenusettingController extends GetxController {
  final _picker = ImagePicker();
  final MenuModel _menuModel = MenuModel();

  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  // 메뉴 생성. 다시 해당 푸드트럭으로 돌아갈 수 있게끔 String을 받게 해둠.
  Future<String> createMenu(String foodtruckid, String menuName,
      String menuPrice, String menuDescription, File? file) async {
    return _menuModel.createMenu(
        foodtruckid, menuName, menuPrice, menuDescription, file);
  }

  // 이미지 갤러리에서 선택 <- 되는지 확인 후에 이미지 파일유효성 검사 코드 넣기.
  Future<File?> getFoodTruckImgGaller() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }
}
