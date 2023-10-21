import 'package:file_sharing/headers.dart';

class FileInfo {
  final String name;
  final bool isFile;
  final int _size;
  final List<FileInfo> files;

  static const String name_ = 'name';
  static const String isFile_ = 'is_file';
  static const String fileInfo_ = 'file_info';
  static const String size_ = 'size';
  static const String files_ = 'files';

  FileInfo({
    required this.name,
    required this.isFile,
    List<FileInfo>? files,
    int size = 0,
  })  : _size = size,
        files = files ?? [];

  FileInfo.dummy({
    this.name = '',
    this.isFile = false,
    List<FileInfo>? files,
    int size = 0,
  })  : _size = size,
        files = files ?? [];

  toJson() {
    return {
      name_: name,
      isFile_: isFile,
      size_: size,
      files_: files.map((e) => e.toJson()).toList(),
    };
  }

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    bool isFile = json[isFile_] ?? true;
    return FileInfo(
      name: json[name_] ?? '',
      isFile: isFile,
      size: isFile ? json[size_] ?? 0 : 0,
      files: isFile
          ? []
          : ((json[files_] as List?) ?? [])
              .map((e) => FileInfo.fromJson(e))
              .toList(),
    );
  }

  static Future<FileInfo> fromDirectory({
    required String name,
    required Directory directory,
  }) async {
    final contents = directory.listSync();
    final fileInfos = <FileInfo>[];

    for (var entity in contents) {
      if (entity is File) {
        String filename = entity.uri.toFilePath();
        int index = filename.lastIndexOf('\\');
        if (index != -1 && filename.length >= index) {
          filename = filename.substring(index + 1);
        }
        fileInfos.add(
          FileInfo.file(
            name: filename,
            size: await entity.length(),
          ),
        );
      } else if (entity is Directory) {
        String filename = entity.uri.toFilePath();
        filename = filename.substring(0, filename.length - 1);

        int index = filename.lastIndexOf('\\');
        if (index != -1 && filename.length >= index) {
          filename = filename.substring(index + 1);
        }
        fileInfos.add(
          await fromDirectory(
            name: filename,
            directory: entity,
          ),
        );
      }
    }

    final objc = FileInfo(
      name: name,
      isFile: false,
      files: fileInfos,
    );

    return objc;
  }

  factory FileInfo.file({required String name, required int size}) {
    return FileInfo(
      name: name,
      isFile: true,
      size: size,
    );
  }
  int get size {
    if (isFile) {
      return _size;
    } else {
      int size = 0;
      for (int i = 0; i < files.length; i++) {
        size += files[i].size;
      }
      return size;
    }
  }

  printInfo({FileInfo? f}) {
    f = f ?? this;
    if (f.isFile) {
    } else {
      for (var file in files) {
        file.printInfo();
      }
    }
  }
}
