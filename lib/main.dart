import 'package:flutter/material.dart';
import 'package:genarator_formul_flutter/HomePageMenu/homePageMenu.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF242F3C);
    final backgroundColor = const Color(0xFF212B38);
    return new MaterialApp(
        title: 'Generator Formul Title',
        theme: new ThemeData(
          primaryColor: primaryColor ,
          backgroundColor: backgroundColor,
        ),
        home: new HomePage());
  }
}
