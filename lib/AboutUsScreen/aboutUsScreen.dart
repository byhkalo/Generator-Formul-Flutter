import 'package:flutter/material.dart';

enum ProfileItemType {
  student,
  professor,
}

class ProfileItem {
  String title;
  String avatarPath;
  String bioText;
  ProfileItemType type;

  ProfileItem(this.title, this.avatarPath, this.bioText, this.type);
}

class AboutUsScreen extends StatefulWidget {
  final calculatorItems = [
    new ProfileItem(
        "Katarzyna Burczyk",
        "assets/images/site/studentAvatar.jpg",
        "Inżynier at SolarWinds\n\nAutor servisu Generator Formuł\n\nAGH University of Science and Technology\n\nWydział Elektrotechniki, Automatyki, Informatyki i Inżynierii Biomedycznej",
        ProfileItemType.student),
    new ProfileItem(
        "Radosław Klimek",
        "assets/images/site/img3_asd.jpg",
        "Radosław Klimek, dr inż.\n\nWydział Elektrotechniki, Automatyki, Informatyki i Inżynierii Biomedycznej\n\nWEAIiIB-kis, Katedra Informatyki Stosowanej",
        ProfileItemType.professor)
  ];

  @override
  createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  TextStyle titleFont =
      new TextStyle(fontSize: 18.0, color: const Color(0xFFA6B9CB));
  TextStyle _smallerFont =
      new TextStyle(fontSize: 14.0, color: const Color(0xFF7F8F99));

  final myTextNameController = new TextEditingController();
  final myTextVariablesController = new TextEditingController();
  final myTexNumbClausesController = new TextEditingController();

  @override
  void dispose() {
    myTextNameController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  linkedinButtonAction() {}

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

  Widget _buildRow(ProfileItem item) {
    switch (item.type) {
      case ProfileItemType.student:
        return studentCell(item);
      case ProfileItemType.professor:
        return professorCell(item);
      default:
        return new Text('no types');
    }
  }

  Widget studentCell(ProfileItem item) {
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
              new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage(item.avatarPath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Text(
                item.bioText,
                style: new TextStyle(fontSize: 6.0, color: Colors.green),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
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
                onPressed: linkedinButtonAction,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    new Radius.circular(20.0),
                  ),
                ),
                fillColor: Colors.green,
                child: new Text(
                  'LinkedIn',
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

  Widget professorCell(ProfileItem item) {
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
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage(item.avatarPath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
              new RichText(
                text: new TextSpan(
                  text: item.bioText,
                  style: new TextStyle(fontSize: 14.0, color: Colors.red),
                ),
              ),
              new Padding(padding: const EdgeInsets.only(left: 16.0)),
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
                onPressed: linkedinButtonAction,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    new Radius.circular(20.0),
                  ),
                ),
                fillColor: Colors.red,
                child: new Text(
                  'LinkedIn',
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
