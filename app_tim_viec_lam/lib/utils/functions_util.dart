
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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

  static Future getCV() async {
    final FilePickerResult? result =  await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf']
    );

    if (result == null) {
      return null;
    } else if (result.paths.first == null){
      return null;
    } else {
      return result.paths.first;
    }
  }

  static getFile() async {
    final String? path = await getCV();
    if (path == null) return null;
    else return File(path);
  }
}