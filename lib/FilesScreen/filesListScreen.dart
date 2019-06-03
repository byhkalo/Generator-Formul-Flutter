import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:genarator_formul_flutter/FilesDetailScreen/fileDetailScreen.dart';
import 'package:genarator_formul_flutter/Services/FilesStorageService.dart';
import 'dart:collection';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class FilesListScreen extends StatefulWidget {
  @override
  createState() => FilesListScreenState();
}

class FilesListScreenState extends State<FilesListScreen> {
  var _suggestions = new List<FileSystemEntity>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final FilesStorageService filesStorageService = FilesStorageService();

  @override
  Widget build(BuildContext context) {
    var sdf = filesStorageService.localFiles();
    sdf.then((list) =>
        setState(() {
          _suggestions = list;
        })
    );

    return new Container(
      color: const Color(0xFF212B38),
      child: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _suggestions.length*2,
          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            final index = i ~/ 2;
            var fileName = basename(_suggestions[index].path);
            return _buildRow(fileName, index);
          }),
    );
  }

  Color _color(intIndex) {
    final colors = [Colors.green, Colors.deepPurple, Colors.cyan, Colors.yellowAccent, Colors.red];
    return colors[intIndex % colors.length];
  }

  void clickedOn(int index) {
    var file = new File(_suggestions[index].path);
    var detailScreen = new FileDetailScreen();
    detailScreen.file = file;
    Navigator.of(this.context).push(new MaterialPageRoute(builder: (context) => detailScreen));
  }

  Widget _buildRow(String header, int index) {
    var card = new Card(
      color: Color(0x25313F),
      margin: const EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Flexible(
                child:
                new Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _color(index),
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                header,
                style: new TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFFA6B9CB),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Flexible(
                child:
                new Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              ),
            ],
          ),
        ],
      ),
    );
    return new GestureDetector(onTap: () {
      this.clickedOn(index);
    }, child: card,);
  }
}
