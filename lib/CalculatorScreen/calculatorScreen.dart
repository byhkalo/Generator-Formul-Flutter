import 'package:flutter/material.dart';
import 'package:genarator_formul_flutter/Services/FilesStorageService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

enum CalculatorItemType {
  basicSettings,
  additionalSettings,
  numberClauses,
  lengthClause,
  generateFormula
}

class CalculatorItem {
  String title;
  CalculatorItemType type;

  CalculatorItem(this.title, this.type);
}

class CalculatorScreen extends StatefulWidget {
  final calculatorItems = [
    new CalculatorItem("Basic Settings", CalculatorItemType.basicSettings),
    new CalculatorItem(
        "Additional Settings", CalculatorItemType.additionalSettings),
    new CalculatorItem(
        "Number of Clauses Settings", CalculatorItemType.numberClauses),
    new CalculatorItem(
        "Length of Clause Settings", CalculatorItemType.lengthClause),
    new CalculatorItem("Generate Formula", CalculatorItemType.generateFormula)
  ];

  @override
  createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  TextStyle titleFont =
  new TextStyle(fontSize: 18.0, color: const Color(0xFFA6B9CB));
  TextStyle _smallerFont =
  new TextStyle(fontSize: 14.0, color: const Color(0xFF7F8F99));

  final myTextNameController = new TextEditingController();
  final myTextVariablesController = new TextEditingController();
  final myTexNumbClausesController = new TextEditingController();

  final FilesStorageService filesStorageService = FilesStorageService();

  @override
  void dispose() {
    myTextNameController.dispose();
    super.dispose();
  }

  //Sending Values

  //generator Type
  String generatorLengthType = 'Standard';

  //clauses Number
  double clausesNumberCount = 1.0;
  double minValue = 1.0;
  double maxValue = 1000.0;
  String clausesNumberType = 'fixed';

  //clauses Length
  String clausesLengthType = 'fixed';
  int minLengthValue = 1;
  int maxLengthValue = 50;
  int clausesLengthCount = 1;

  //variables Number
  int variablesNumber = 1;

  //negation Propability
  double negationPropability = 0.0;

  //length Clauses
  List<DropdownMenuItem<int>> lengthClauses() {
    var lengthClauses = new List<DropdownMenuItem<int>>();
    for (var index = minLengthValue; index < maxLengthValue; index++) {
      lengthClauses.add(new DropdownMenuItem(
        value: index,
        child: new Text('$index'),
      ));
    }
    return lengthClauses;
  }

  @override
  initState() {
    super.initState();
  }

  generateButtonAction() {
    String fileName = myTextNameController.text == '' ? 'tempName' : myTextNameController.text;
    int variablesNumber = myTextVariablesController.text == '' ? 1 : int.parse(
        myTextVariablesController.text);
    int repetitionsNumber = 1;
    var url = 'http://byhkalo-001-site1.gtempurl.com/api/v1/generationFormulas';
    http.post(url, body: json.encode({
      'ClausesNumberType': clausesNumberType,
      'ClausesNumberCount': clausesNumberCount.round(),
      'ClausesLengthType': clausesLengthType,
      'ClausesLengthCount': clausesLengthCount.round(),
      'FileName': fileName,
      'VariablesNumber': variablesNumber,
      'GeneratorLengthType': generatorLengthType,
      'RepetitionsNumber': repetitionsNumber,
      'NegationPropability': negationPropability
    }), headers: {'Content-Type': 'application/json'}).then((response) {


      print("Response status: ${response.statusCode}");
      String filePath = response.headers["content-disposition"].split("filename=").last;
      print(filePath);
      String fileName = basename(filePath).replaceFirst("\"", "");

      print("Response status: $fileName");
      filesStorageService.writeFile(fileName, response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: const Color(0xFF212B38),
      child: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.calculatorItems.length * 2,
          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            final index = i ~/ 2;
            return _buildRow(widget.calculatorItems[index]);
          }),
    );
  }

  Widget _buildRow(CalculatorItem item) {
    switch (item.type) {
      case CalculatorItemType.basicSettings:
        return basicCell(item);
      case CalculatorItemType.additionalSettings:
        return additionalCell(item);
      case CalculatorItemType.numberClauses:
        return numberClausesCell(item);
      case CalculatorItemType.lengthClause:
        return lengthClauseCell(item);
      case CalculatorItemType.generateFormula:
        return generateFormula(item);
      default:
        return new Text('no types');
    }
  }

  Widget basicCell(CalculatorItem item) {
    return new Card(
      color: const Color(0x25313F),
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
                  color: Colors.green,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                item.title,
                style: new TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFFA6B9CB),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                'FileName',
                style: _smallerFont,
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Flexible(
                child: new TextFormField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter a search term',
                      hintStyle: _smallerFont,
                      labelStyle: _smallerFont),
                  style: _smallerFont,
                  controller: myTextNameController,
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                'Number of Variables',
                style: _smallerFont,
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Flexible(
                child: new TextFormField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: '1-10',
                      hintStyle: _smallerFont,
                      labelStyle: _smallerFont,),
                  style: _smallerFont,
                  controller: myTextVariablesController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget additionalCell(CalculatorItem item) {
    return new Card(
      color: const Color(0x25313F),
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
                  color: Colors.deepPurpleAccent,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                item.title,
                style: new TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFFA6B9CB),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                'Generator Type',
                style: _smallerFont,
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new DropdownButton<String>(
                value: generatorLengthType,
                style: _smallerFont,
                onChanged: (String newValue) {
                  setState(() {
                    generatorLengthType = newValue;
                  });
                },
                items: <String>['Standard', 'Alf', 'Mt', 'XorSwift'].map(
                      (String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                'Negation Propability',
                style: _smallerFont,
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new DropdownButton<double>(
                value: negationPropability,
                style: _smallerFont,
                onChanged: (double newValue) {
                  setState(() {
                    negationPropability = newValue;
                  });
                },
                items: <double>[
                  0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0].map((
                    double tempValue) {
                  return new DropdownMenuItem<double>(
                    value: tempValue, child: new Text('$tempValue'),);
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget numberClausesCell(CalculatorItem item) {
    void handleRadioValueChanged(String value) {
      setState(() {
        clausesNumberType = value;
        switch (value) {
          case 'fixed':
            minValue = 1.0;
            maxValue = 1000.0;
            clausesNumberCount = 1.0;
            break;
          case 'max':
            minValue = 1000.0;
            maxValue = 1000.0;
            clausesNumberCount = 1000.0;
            break;
          case 'relative':
            minValue = 2.0;
            maxValue = 8.0;
            clausesNumberCount = 2.0;
            break;
          default:
            break;
        }
        final presentValue = clausesNumberCount.round();
        myTexNumbClausesController.text = '$presentValue';
      });
    }

    return new Card(
      color: const Color(0x25313F),
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
                  color: Colors.cyanAccent,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                item.title,
                style: new TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFFA6B9CB),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new Radio<String>(
              value: 'fixed',
              groupValue: clausesNumberType,
              onChanged: handleRadioValueChanged,
              activeColor: Colors.cyanAccent,
            ),
            new Text(
              'Fixed',
              style: _smallerFont,
            ),
            new Radio<String>(
              value: 'max',
              groupValue: clausesNumberType,
              onChanged: handleRadioValueChanged,
              activeColor: Colors.cyanAccent,
            ),
            new Text(
              'Max',
              style: _smallerFont,
            ),
            new Radio<String>(
              value: 'relative',
              groupValue: clausesNumberType,
              onChanged: handleRadioValueChanged,
              activeColor: Colors.cyanAccent,
            ),
            new Text(
              'Relative',
              style: _smallerFont,
            ),
          ]),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Flexible(
                child: new TextFormField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter a search term',
                      hintStyle: _smallerFont),
                  style: _smallerFont,
                  controller: myTexNumbClausesController,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Flexible(
                child: new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    'easy SAT',
                    style: _smallerFont,
                  ),
                ),
              ),
              new Flexible(
                child: new Align(
                  alignment: Alignment.centerRight,
                  child: new Text(
                    'easy UNSAT',
                    style: _smallerFont,
                  ),
                ),
              ),
              new Padding(padding: const EdgeInsets.only(right: 16.0)),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Flexible(
                child: new Slider(
                  value: clausesNumberCount,
                  min: minValue,
                  max: maxValue,
                  divisions: maxValue.round(),
                  activeColor: Colors.cyanAccent,
                  inactiveColor: Colors.grey,
                  label: '${clausesNumberCount.round()}',
                  onChanged: (double value) {
                    setState(() {
                      clausesNumberCount = value;
                      final presentValue = value.round();
                      myTexNumbClausesController.text = '$presentValue';
                    });
                  },
                ),
              ),
              new Padding(padding: const EdgeInsets.only(right: 16.0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget lengthClauseCell(CalculatorItem item) {
    void handleRadioValueChanged(String value) {
      setState(() {
        clausesLengthType = value;
      });
    }

    return new Card(
      color: const Color(0x25313F),
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
                  color: Colors.amber,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                item.title,
                style: new TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFFA6B9CB),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new Radio<String>(
              value: 'fixed',
              groupValue: clausesLengthType,
              onChanged: handleRadioValueChanged,
              activeColor: Colors.amber,
            ),
            new Text(
              'Fixed',
              style: _smallerFont,
            ),
            new Radio<String>(
              value: 'max',
              groupValue: clausesLengthType,
              onChanged: handleRadioValueChanged,
              activeColor: Colors.amber,
            ),
            new Text(
              'Max',
              style: _smallerFont,
            ),
            new Radio<String>(
              value: 'average',
              groupValue: clausesLengthType,
              onChanged: handleRadioValueChanged,
              activeColor: Colors.amber,
            ),
            new Text(
              'Average',
              style: _smallerFont,
            ),
          ]),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new DropdownButton<int>(
                value: clausesLengthCount,
                style: _smallerFont,
                onChanged: (int newValue) {
                  setState(() {
                    clausesLengthCount = newValue;
                  });
                },
                items: lengthClauses(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget generateFormula(CalculatorItem item) {
    return new Card(
      color: const Color(0x25313F),
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
                  color: Colors.red,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                item.title,
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
          new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Flexible(
                child: new Text(
                  'Lorem ipsum dolor sit amet, ut sea stet antiopam, adhuc suavitate cu his. Te ipsum everti recteque qui, menandr',
                  style: _smallerFont,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(right: 16.0)),
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
          new Row(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0)),
              new RawMaterialButton(
                onPressed: generateButtonAction,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    new Radius.circular(20.0),
                  ),
                ),
                fillColor: Colors.red,
                child: new Text(
                  'Generate',
                  style: _smallerFont,
                ),
              ),
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
  }
}
