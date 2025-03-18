import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FunctionsUtil {
  static Future<bool> checkUrl(String url) async {
    final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
  }

  static Future getImageGallery() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
  }

  static Future getImageCamera() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
  }
}