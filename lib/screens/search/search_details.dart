import 'package:flutter/material.dart';
import 'package:ultravmobile/screens/call/call_screen.dart';
import 'package:ultravmobile/screens/settings/settings.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import "../../model/franqueados.dart";
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';

class SearchDetails extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SearchDetailsPage();
  }
}

class SearchDetailsPage extends StatefulWidget {
  SearchDetailsPage();

  @override
  _SearchDetailsPage createState() => _SearchDetailsPage();
}

class _SearchDetailsPage extends State<SearchDetailsPage> {
  Franqueados franqueado;
  var bloc = BlocProvider.getBloc<BlocSearchProfessional>();
  @override
  void initState() {
    super.initState();
    franqueado = bloc.selectFranqueado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(back: true),
        body: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: HexColor("#DDDDDD"),
            child: Column(children: [
              placeGeneral("Detalhe da Assistência"),
              Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                          // margin: EdgeInsets.all(25),

                          child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: CircleAvatar(
                        radius: 90,
                        backgroundImage: NetworkImage(franqueado.foto)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35, left: 25, right: 25),
                    child: Text(
                      franqueado.nome,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: Text(
                      franqueado.endereco,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 15, left: 25, right: 25),
                      child: Text(
                        franqueado.telefone,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => CallPage()));
                    },
                    child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Container(
                            padding: EdgeInsets.all(15),
                            margin:
                                EdgeInsets.only(top: 55, left: 35, right: 35),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Text(
                              "Fazer Chamado",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ))),
                  )
                ],
              ))))
            ])));
  }
}
