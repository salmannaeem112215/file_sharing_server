import 'package:file_sharing/headers.dart';

class FileReader {
  String? loadFromFile(String filename) {
    try {
      return File(filename).readAsStringSync();
    } catch (e) {
      return null;
    }
  }

  Object? loadFromJsonFile(String filename) {
    try {
      final jsonString = loadFromFile(filename);
      if (jsonString == null) return null;

      final data = json.decode(jsonString);
      return data;
    } catch (e) {
      return null;
    }
  }

  bool saveInFile({
    required String filePath,
    required String data,
  }) {
    try {
      File file = File(filePath);
      file.writeAsStringSync(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool saveJsonInFile({
    required String filePath,
    required Object data,
  }) {
    try {
      final jsonString = json.encode(data);
      File file = File(filePath);
      file.writeAsStringSync(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<FileInfo?> getFileInfo(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (directory.existsSync()) {
      return FileInfo.fromDirectory(
        name: directoryPath,
        directory: directory,
      );
    } else {
      return null;
    }
  }
}
