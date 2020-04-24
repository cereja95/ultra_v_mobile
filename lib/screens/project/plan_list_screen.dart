import 'package:flutter/material.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/screens/project/listProject.dart';
import 'package:ultravmobile/screens/project/plan_list.dart';
import 'package:ultravmobile/screens/project/room_list_screen.dart';
import 'package:ultravmobile/screens/settings/settings.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import '../../extra/Constants.dart' as Constants;

class MyAppPlanList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlanListPage(),
    );
  }
}

class PlanListPage extends StatefulWidget {
  PlanListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlanListPage createState() => _PlanListPage();
}

class _PlanListPage extends State<PlanListPage> {
  var bloc = BlocProvider.getBloc<BlocPlan>();

  Function onTapped(Project item) {
    bloc.selectPlan = item;
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => RoomListScreen()))
        .then((o) {
      bloc.getAllPlans();
    });
    ;
  }

  @override
  void initState() {
    super.initState();
    initBinds();
    bloc.getAllPlans();
  }

  void _showDialog(title, describe, {bool more: false}) {
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

  void _showDialogRoom(title, describe, {bool more: false}) {
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
    bloc.alertRoom = this._showDialog;
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
              // InkWell(
              //     onTap: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Container(
              //       alignment: Alignment.topLeft,
              //       margin: EdgeInsets.only(
              //           left: 16, right: 16, top: 35, bottom: 0),
              //       child: Icon(
              //         Icons.arrow_back,
              //         color: HexColor("#FFFFFF"),
              //         size: 28,
              //       ),
              //     )),
              placeGeneral("Projetos"),
              Expanded(child: listStream()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: new FloatingActionButton(
                    backgroundColor: Colors.purple,
                    onPressed: () {
                      planAddDialog(context);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (BuildContext context) => ProjectRoom()));
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
    return new StreamBuilder<List<Project>>(
        stream: bloc.planListStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return PlanListCell([], onTapped);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }

          return PlanListCell(snapshot.data, onTapped);
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)));
  }

  Widget txtGenericModal(name, controller) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 15, left: 1, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.grey)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 18),
          labelStyle: TextStyle(fontSize: 18),
          hintText: name,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    ));
  }

  void planAddDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
              width: 300,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Center(
                            child: Text(
                          "Novo Projeto",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ))),
                    txtModalGeneral("Nome", bloc.controllerNameProject),
                    txtModalGeneral("Plano Base", bloc.controllerScaleProject,
                        keyboardType: TextInputType.number),
                    streamButtonModal(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pop();
                      bloc.setProject();
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget progressModal(double topConst, double bottomConst) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: topConst,
          bottom: bottomConst,
        ),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)));
  }

  Widget buttonAdd(title, background, color, function) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: InkWell(
            onTap: () {
              function();
            },
            child: Container(
                child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(color: color, fontSize: 18),
                      textAlign: TextAlign.center,
                    )))));
  }

  Widget streamButtonModal(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingAddProjectStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return progressModal(10, 10);
          }
          return buttonAdd(
              'Adicionar Projeto', Colors.purple, Colors.white, function);
        });
  }
}
