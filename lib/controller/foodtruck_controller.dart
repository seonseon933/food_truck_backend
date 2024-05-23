import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FoodTruckController {
  final _picker = ImagePicker();

  Future<File?> getFoodTruckImgGaller() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      return file;
    }
    return null;
  }
}
