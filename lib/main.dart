import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ultravmobile/bloc/bloc_plan.dart';
import 'package:ultravmobile/extra/Prefs.dart';
import 'package:ultravmobile/screens/listRoom/room_list.dart';
import 'package:ultravmobile/screens/project/listProject.dart';
import 'package:ultravmobile/screens/project/planDown.dart';
import 'package:ultravmobile/screens/project/plan_list_screen.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';
import 'package:ultravmobile/screens/search/bloc_professional.dart';
import 'package:ultravmobile/screens/tab_bar/home.dart';
import 'package:ultravmobile/screens/tab_bar/home_franqueado.dart';
import 'package:ultravmobile/screens/tutorial/TutorialOneScreen.dart';
import 'package:ultravmobile/screens/user/login_franqueado_screen.dart';
import 'package:ultravmobile/screens/user/login_screen.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'extra/Constants.dart' as Constants;

void main() => runApp(CheckPage());

class CheckPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocs: [
          Bloc((i) => BlocSearchProfessional()),
          Bloc((i) => BlocProfessional()),
          Bloc((i) => BlocPlan()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ULTRA V',
            theme: ThemeData(
                primaryColor: HexColor(Constants.COLOR_NAV),
                primaryTextTheme: TextTheme(
                    title: TextStyle(color: HexColor(Constants.COLOR_SYSTEM)))),
            //home: MyAppPlanList(),
            //     home: CheckPageFul()
            //home: VideoPlayerApp()
            home: CheckPageFul()
            //Check
            ));
  }
}

class CheckPageFul extends StatefulWidget {
  CheckPageFul({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CheckPageFul createState() => _CheckPageFul();
}

class _CheckPageFul extends State<CheckPageFul> {
  Future<void> goHome() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => HomePage()))
        .then((o) {
      goNextScreen();
    });
  }

  Future<void> goHomeFranq() async {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => HomeFranqueadoPage()))
        .then((o) {
      goNextScreen();
    });
  }

  Future<void> goLogin() async {
    Navigator.of(context)
        .push(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()))
        .then((o) {
      goNextScreen();
    });
  }

  Future<bool> goNextScreen() async {
    var token = await Prefs().getPrefString("token");
    print(token);

    var tutorial = await Prefs().getPrefString("tutorial");
    //  Prefs().setPrefString("tutorial", "0");
    if (tutorial == "1") {
      if (token.isNotEmpty && token != null) {
        var type = await Prefs().getPrefString("type");
        if (type == "2") {
          await goHomeFranq();
        } else {
          await goHome();
        }
      } else {
        await goLogin();
      }
    } else {
      goTutorial();
    }
  }

  Future<Function> goTutorial() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => VideoPlayerScreen()))
        .then((o) {
      goNextScreen();
    });
  }

  @override
  void initState() {
    super.initState();
    goNextScreen();
  }

  Widget progress(double topConst, double bottomConst) {
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(
            top: topConst, bottom: bottomConst, left: 10, right: 10),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                HexColor(Constants.COLOR_SYSTEM))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background_black.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[progress(0, 0)],
        ),
      ),
    );
  }
}
