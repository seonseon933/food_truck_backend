import 'dart:io';

import 'package:food_truck/model/menu_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'app_pages.dart';

class MenuupdateController extends GetxController {
  final _picker = ImagePicker();
  final MenuModel _menuModel = MenuModel();

  void goDetail(foodtruck) {
    Get.offNamed(Routes.FOODTRUCKDETAIL, arguments: foodtruck);
  }

  Future<String> updateMenu(String foodtruckid, String menuid, String menuName,
      String menuPrice, String menuDescription, File? file) async {
    return _menuModel.updateMenu(
        foodtruckid, menuid, menuName, menuPrice, menuDescription, file);
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
