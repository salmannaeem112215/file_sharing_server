import 'package:file_sharing/headers.dart';
import 'package:file_sharing/modules/_headers.dart';

class InfoStorage {
  InfoStorage() : _value = _read();
  Info _value;
  Info get value {
    return _value;
  }

  set value(Info newValue) {
    final oldValue = _value;
    if (oldValue != newValue) {
      _value = newValue;
    }
    _save();
  }

  static Info _read() {
    try {
      final jsonData = FileReader().loadFromJsonFile(kInfoFilename);
      if (jsonData != null) {
        return Info.fromJson(jsonData as Map<String, dynamic>);
      }
    } catch (e) {
      print('ERROR in reading INFo, Message $e');
    }
    return Info.dummy();
  }

  _save() {
    FileReader().saveJsonInFile(
      filePath: kInfoFilename,
      data: value.toJson(
        hidePassword: false,
      ),
    );
  }

  update() {
    FileReader().getFileInfo(AppRoutes.downloadName);
    value = _read();
  }
}
