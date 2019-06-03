import 'dart:async';
import 'dart:io';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class FilesStorageService {


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<dynamic> localFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    var files = <FileSystemEntity>[];
    var completer = new Completer();
    var lister = directory.list(recursive: false);
    lister.listen (
            (file) => files.add(file),
        // should also register onError
        onDone:   () => completer.complete(files)
    );
    return completer.future;
  }

  Future<File> localFile(String name) async {
    final path = await _localPath;
    return new File('$path/$name');
  }

  Future<String> readText(String fileName) async {
    try {
      final file = await localFile(fileName);

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return "";
    }
  }

  Future<File> writeFile(String fileName, String text) async {
    final file = await localFile(fileName);

    // Write the file
    return file.writeAsString(text);
  }
}