import 'package:flutter/material.dart';
import 'package:ultravmobile/bloc/login_bloc.dart';
import 'package:ultravmobile/screens/tab_bar/home_franqueado.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../../extra/Constants.dart' as Constants;
import '../tab_bar/home.dart';

class LoginFranqueadoScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LoginFranqueadoPage(title: 'Flutter Demo Home Page');
  }
}

class LoginFranqueadoPage extends StatefulWidget {
  LoginFranqueadoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginFranqueadoPage createState() => _LoginFranqueadoPage();
}

class _LoginFranqueadoPage extends State<LoginFranqueadoPage> {
  var bloc = LoginBloc();
  @override
  void initState() {
    super.initState();
    initBinds();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  //MARK: - BIND FUNCTIONS
  void goHome() => Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => HomeFranqueadoPage()));

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
    bloc.alertLogin = this._showDialog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(back: true),
        body: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_black.png"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              placeGeneral("Login Franqueado"),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: SingleChildScrollView(
                          child: Container(
                              child: Column(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(top: 20, left: 35, right: 35),
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
                            margin:
                                EdgeInsets.only(top: 15, left: 35, right: 35),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            child: TextField(
                              controller: bloc.controllerPassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 17),
                                hintText: 'Senha',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(minWidth: double.infinity),
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: 15, left: 35, right: 35),
                                  child: Text(
                                    "Esqueceu a senha?",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.left,
                                  ))),
                          streamButtonLogin(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            bloc.makeLoginFranq();
                          })
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(bottom: 30, left: 50, right: 50, top: 30),
                          //   child: Image(image: AssetImage('assets/pipe.png')),
                          // ),
                        ],
                      )))))
            ])));
  }

  Widget streamButtonLogin(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingLoginStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          //para tratar quando nõ vem resposta, sempre que comeca vem null
          // if (snapshot.hasError) {}
          // if (!snapshot.hasData) {}
          if (snapshot.data ?? false) {
            return progress(10, 10);
          }
          return buttonLogin(function);
        });
  }

  Widget buttonLogin(function) {
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
                margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Text(
                  "Entrar",
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
