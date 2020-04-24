import 'package:flutter/material.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/screens/project/listProject.dart';
import 'package:ultravmobile/screens/project/wall_list.dart';
import 'package:ultravmobile/screens/prototype/wall_prototype.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import '../../extra/Constants.dart' as Constants;

class WallsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WallsListPage();
  }
}

class WallsListPage extends StatefulWidget {
  WallsListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WallsListPage createState() => _WallsListPage();
}

class _WallsListPage extends State<WallsListPage> {
  var bloc = BlocProvider.getBloc<BlocPlan>();

  Function onTapped(Wall item) {
    bloc.selectWall = item;
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => WallPrototypeScreen()))
        .then((o) {
      bloc.getPlan();
      bloc.initWalls();
    });
  }

  @override
  void initState() {
    super.initState();
    bloc.initWalls();
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
              placeGeneral("Paredes"),
              Expanded(child: listStream()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: new FloatingActionButton(
                    backgroundColor: Colors.purple,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ProjectRoom()));
                    },
                    child: new Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ])));
  }

  Widget listStream() {
    return new StreamBuilder<List<Wall>>(
        stream: bloc.wallsListStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return WallListCell([], onTapped);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }
          print(snapshot.data);
          return WallListCell(
              (snapshot.data.where((f) => f.wallType == 1).toList()), onTapped);
        });
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
}
