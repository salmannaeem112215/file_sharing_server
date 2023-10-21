import 'package:file_sharing/headers.dart';

class Info {
  final String username;
  final String password;
  final List<String> filenames;

  static const String username_ = 'username';
  static const String password_ = 'password';
  static const String filenames_ = 'filenames';

  Info({
    required this.password,
    required this.username,
    required this.filenames,
  });

  Info.dummy({
    String? username,
    String? password,
    List<String>? filenames,
  })  : username = username ?? '',
        password = password ?? '',
        filenames = filenames ?? [];

  // json decode and extract values from json map
  factory Info.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Info.fromJson(json);
  }
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      username: json[username_] ?? [],
      password: json[password_] ?? '',
      filenames:
          ((json[filenames_] as List?) ?? []).map((e) => e as String).toList(),
    );
  }

  // extract the values from json map
  Map<String, dynamic> toJson({hidePassword = true}) {
    if (hidePassword) {
      return {
        username_: username,
        filenames_: filenames,
      };
    } else {
      return {
        username_: username,
        password_: password,
        filenames_: filenames,
      };
    }
  }
}
