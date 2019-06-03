import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genarator_formul_flutter/Services/FilesStorageService.dart';
import 'package:path/path.dart';

class FileDetailScreen extends StatefulWidget {
  var file = new File("");

  @override
  createState() => FileDetailScreenState();
}

class FileDetailScreenState extends State<FileDetailScreen> {
  var _text = "";
  final FilesStorageService filesStorageService = FilesStorageService();

  @override
  Widget build(BuildContext context) {
    filesStorageService
        .readText(basename(this.widget.file.path))
        .then((text) => setState(() {
              _text = text;
            }));
    return new Scaffold(
        backgroundColor: const Color(0xFF212B38),
        appBar: new AppBar(
          // here we display the title corresponding to the fragment
          // you can instead choose to have a static title
          title: new Text(basename(this.widget.file.path)),
        ),
        body: new SizedBox(
          width: double.infinity,
          child: new Container(
              color: const Color(0xFF212B38),
              child: new SingleChildScrollView(
                child: new Text(
                  _text,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFFA6B9CB),
                      fontWeight: FontWeight.normal),
                ),
              )),
        ));
  }
}
