import 'package:flutter/material.dart';
import 'package:ultravmobile/model/settings.dart';
import 'package:ultravmobile/screens/settings/ConfigurationCell.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:ultravmobile/utils/general_widgets.dart';

class ConfigurationMicro extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ConfigurationMicro();
  }
}

class _ConfigurationMicro extends State<ConfigurationMicro> {
  String email = "";
  String senha = "";
  //List<Map<String, String>> _products = [];
  List<Settings> _products = [];

  @override
  void initState() {
    setState(() {
      _products.add(Settings(
        "Sair",
        "exit",
      ));
    });

    super.initState();
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
            child: Container(
                child: Column(
              children: <Widget>[
                placeGeneral("Menu de Opções"),
                Expanded(child: ConfigurationCell(_products, context))
              ],
            ))));
  }
}

Widget navBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
        height: 40, child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
    backgroundColor: HexColor("#333333"),
  );
}

Widget place(title) {
  return Container(
    alignment: Alignment.topLeft,
    margin: EdgeInsets.only(top: 0, bottom: 15),
    padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
    decoration: BoxDecoration(
      color: Colors.purple,
      // borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    child: Text(
      title,
      style: TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}
