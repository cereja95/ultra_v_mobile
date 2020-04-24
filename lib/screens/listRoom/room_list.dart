import 'package:flutter/material.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/point.dart';
import 'package:ultravmobile/screens/listRoom/room_cell.dart';
import 'package:ultravmobile/screens/search/search_details.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';

class MyAppRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: RoomList(),
      ),
    );
  }
}

class RoomList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RoomListPage();
  }
}

class RoomListPage extends StatefulWidget {
  RoomListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoomListPage createState() => _RoomListPage();
}

class _RoomListPage extends State<RoomListPage> {
  List<Room> _products = [];

  Function onTapped() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SearchDetails()));
  }

  @override
  void initState() {
    super.initState();
    var p = Room(name: 'Quarto da menina');

    setState(() {
      _products.add(p);
    });
    var p2 = Room(name: 'Sala de estar');
    setState(() {
      _products.add(p2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(),
        body: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_black.png"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              placeGeneral("Cômodos"),
              Expanded(child: RoomCell(_products, onTapped))
            ])));
  }
}

Widget navbar(title, function) {
  return Row(
    children: <Widget>[
      InkWell(
          onTap: () {
            function();
          },
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 0),
            child: Icon(
              Icons.arrow_back,
              color: HexColor("#FFFFFF"),
              size: 28,
            ),
          )),
      Expanded(
          flex: 1,
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 0, right: 44, top: 30, bottom: 0),
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 26),
                textAlign: TextAlign.center,
              ))),
    ],
  );
}
