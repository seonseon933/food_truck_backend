import 'dart:io';

import 'package:food_truck/model/menu_model.dart';
import 'package:image_picker/image_picker.dart';

class FoodTruckController {
  final _picker = ImagePicker();
  final MenuModel _menuModel = MenuModel();

  // 이미지 갤러리에서 선택
  Future<File?> getFoodTruckImgGaller() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }

  // 메뉴 불러오기
  Future<List<Map<String, dynamic>>> getFoodTruckMenuData(
      String foodtruckId) async {
    return await _menuModel.getFoodTruckMenuData(foodtruckId);
  }

  // 메뉴 생성. 다시 해당 푸드트럭으로 돌아갈 수 있게끔 String을 받게 해둠.
  Future<String> createMenu(String foodtruckid, String menuName,
      String menuPrice, String menuDescription, File? file) async {
    return _menuModel.createMenu(
        foodtruckid, menuName, menuPrice, menuDescription, file);
  }

  // 메뉴 수정
  Future<String> updateMenu(String foodtruckid, String menuid, String menuName,
      String menuPrice, String menuDescription, File? file) async {
    return _menuModel.updateMenu(
        foodtruckid, menuid, menuName, menuPrice, menuDescription, file);
  }

  // 메뉴 삭제
  Future<String> deleteMenu(String foodtruckid, String menuid) async {
    return _menuModel.deleteMenu(foodtruckid, menuid);
  }
}
