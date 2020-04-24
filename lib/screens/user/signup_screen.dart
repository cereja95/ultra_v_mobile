import 'package:flutter/material.dart';
import 'package:ultravmobile/bloc/signup_bloc.dart';
import 'package:ultravmobile/screens/tab_bar/home.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../extra/Constants.dart' as Constants;

class SignupScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SignupPage();
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  var bloc = SignUpBloc();

  @override
  void initState() {
    initBinds();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  //MARK: - BIND FUNCTIONS
  void goHome() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => HomePage()));

  void _showDialog(
    title,
    describe,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(describe),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //MARK: -  FUNCTIONS
  void initBinds() {
    bloc.goHome = this.goHome;
    bloc.alert = this._showDialog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(back: true),
        body: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_black.png"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              placeGeneral("Cadastro de Usuário"),
              Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 5, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  controller: bloc.controllerName,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Nome',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  controller: bloc.controllerEmail,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Email',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  controller: bloc.controllerPhone,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Telefone',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: bloc.controllerPassword,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Senha',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: bloc.controllerConfirmPassword,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Confirmação de Senha',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              streamButtonSign(() {
                                bloc.makeSignUp();
                              })
                              // Container(
                              //   margin:
                              //       EdgeInsets.only(bottom: 30, left: 50, right: 50, top: 30),
                              //   child: Image(image: AssetImage('assets/pipe.png')),
                              // ),
                              // Cs
                            ],
                          ))))
            ])));
  }

  Widget streamButtonSign(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingSignStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          //para tratar quando nõ vem resposta, sempre que comeca vem null
          // if (snapshot.hasError) {}
          // if (!snapshot.hasData) {}
          if (snapshot.data ?? false) {
            return progress(35, 10);
          }
          return buttonSigUp(function);
        });
  }

  Widget buttonSigUp(function) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: InkWell(
            onTap: () {
              function();
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => HomePage()));
            },
            child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 35, left: 35, right: 35),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Text(
                  "Cadastrar",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ))));
  }

  Widget progress(double topConst, double bottomConst) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: topConst,
          bottom: bottomConst,
        ),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                HexColor(Constants.COLOR_SYSTEM))));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
