import 'package:flutter/material.dart';
import 'package:ultravmobile/model/cliente.dart';
import 'package:ultravmobile/screens/call/call_screen.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import "../../model/franqueados.dart";

class ClientDetails extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ClientDetailsPage();
  }
}

class ClientDetailsPage extends StatefulWidget {
  ClientDetailsPage();

  @override
  _SearchDetailsPage createState() => _SearchDetailsPage();
}

class _SearchDetailsPage extends State<ClientDetailsPage> {
  Cliente franqueado;
  @override
  void initState() {
    super.initState();
    var p = Cliente();
    p.endereco = "Av Gil Veloso, 321, Vila Velha - ES";
    p.foto = "https://i.ytimg.com/vi/P_MlW2zCdUQ/maxresdefault.jpg";
    p.nome = "Julia Costa Silva";
    p.telefone = "(27) 99087-4590";
    p.descricao = "Parede muito úmida e cano exposto";
    p.image = "https://i.ytimg.com/vi/reb0X3O6GwI/maxresdefault.jpg";

    setState(() {
      franqueado = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/gradient_orange.png"),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
                child: Container(
                    // margin: EdgeInsets.all(25),

                    child: Column(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                          left: 16, right: 16, top: 55, bottom: 12),
                      child: Icon(
                        Icons.arrow_back,
                        color: HexColor("#FFFFFF"),
                        size: 28,
                      ),
                    )),
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
                        color: Colors.white,
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
                        color: Colors.white,
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
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Text(
                    "Problema reportado:",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: Text(
                    franqueado.descricao,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(20),
                    child: Image.network(
                      franqueado.image,
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
                          margin: EdgeInsets.only(top: 20, left: 35, right: 35),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Text(
                            "Responder Chamado",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ))),
                )
              ],
            )))));
  }
}
