import 'package:file_sharing/headers.dart';
import 'package:file_sharing/modules/_headers.dart';

class Info {
  final String username;
  final String password;
  final FileInfo fileInfo;

  static const String username_ = 'username';
  static const String password_ = 'password';
  static const String fileInfo_ = FileInfo.fileInfo_;

  Info(
      {required this.password, required this.username, required this.fileInfo});

  Info.dummy({
    String? username,
    String? password,
    FileInfo? fileinfo,
  })  : username = username ?? '',
        password = password ?? '',
        fileInfo = fileinfo ??
            FileInfo(
              name: '',
              isFile: false,
            );

  // json decode and extract values from json map
  factory Info.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Info.fromJson(json);
  }
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      username: json[username_] ?? [],
      password: json[password_] ?? '',
      fileInfo: FileInfo.fromJson(json[fileInfo_] ?? {}),
    );
  }

  // extract the values from json map
  Map<String, dynamic> toJson({hidePassword = true}) {
    if (hidePassword) {
      return {
        username_: username,
        fileInfo_: fileInfo.toJson(),
      };
    } else {
      return {
        username_: username,
        password_: password,
        fileInfo_: fileInfo.toJson(),
      };
    }
  }
}
