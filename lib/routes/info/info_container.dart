import 'package:file_sharing/routes/info/info_storage.dart';

class InfoContainer {
  static final info = InfoStorage();

  static Map<String, dynamic> getValue() {
    return info.value.toJson();
  }

  static bool updateValue(String password) {
    if (password == info.value.password) {
      info.update();
      return true;
    }
    return false;
  }
}
