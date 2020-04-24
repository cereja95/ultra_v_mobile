import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

//Página de criar paredes do Cômodo

class ProjectRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBarGeneral(back: true),
      body: ProjectPage(),
    );
  }
}

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProjectPage createState() => _ProjectPage();
}

class _ProjectPage extends State<ProjectPage> {
  RoomProject room = RoomProject();
  RoomProject doors = RoomProject();
  MyPainter painter = MyPainter();
  List<Point> pointers = [];
  double x = 0;
  double y = 0;
  double planSize = 300;
  double planCm = 500;
  bool isWall = true;

  var controllerStartX = new TextEditingController();
  var controllerStartY = new TextEditingController();
  var controllerFinishX = new TextEditingController();
  var controllerFinishY = new TextEditingController();
  var controllerHeight = new TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();

  var bloc = BlocProvider.getBloc<BlocPlan>();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(focusNode: _nodeText1),
        KeyboardAction(
          focusNode: _nodeText2,
        ),
        KeyboardAction(
          focusNode: _nodeText3,
        ),
        KeyboardAction(
          focusNode: _nodeText4,
        ),
        KeyboardAction(
          focusNode: _nodeText5,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    planSize = 0;
    initScreen();
  }

  void initScreen() {
    bloc.alertRoom2 = _showDialogRoom;
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

  void addLine(isWall) {
    Point pointStart = Point(double.parse(controllerStartX.text),
        double.parse(controllerStartY.text));
    Point pointFinish = Point(double.parse(controllerFinishX.text),
        double.parse(controllerFinishY.text));

    if (!isWall) {
      setState(() {
        planSize = MediaQuery.of(context).size.width - 80;
        doors.lines.add(Line(pointStart, pointFinish,
            height: double.parse(controllerHeight.text)));
        painter.proportional = planSize / planCm;
        painter.planSize = planSize;
        painter.doors = doors;
        controllerStartX.text = controllerFinishX.text;
        controllerStartY.text = controllerFinishY.text;
        controllerFinishX.text = '';
        controllerFinishY.text = '';
      });
    } else {
      setState(() {
        planSize = MediaQuery.of(context).size.width - 80;
        room.lines.add(Line(pointStart, pointFinish,
            height: double.parse(controllerHeight.text)));
        painter.proportional = planSize / planCm;
        painter.planSize = planSize;
        painter.room = room;
        controllerStartX.text = controllerFinishX.text;
        controllerStartY.text = controllerFinishY.text;
        controllerFinishX.text = '';
        controllerFinishY.text = '';
      });
    }
  }

  void deleteLastLine(isWall) {
    if (isWall) {
      setState(() {
        room.lines..removeLast();
        painter.room = room;
      });
    } else {
      setState(() {
        doors.lines..removeLast();
        painter.doors = doors;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    planSize = MediaQuery.of(context).size.width - 80;
    planCm = bloc.selectPlan.scale;
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background_black.png"),
                fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            placeGeneral(bloc.selectRoom.name),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: KeyboardActions(
                        config: _buildConfig(context),
                        child: SingleChildScrollView(
                            child: Container(
                                child: Column(children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "${planCm} x ${planCm} cm",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          metricPlanRefactor(() {
                            deleteLastLine(this.isWall);
                          }, 'Y'),
                          Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              child: CustomPaint(
                                size: Size(planSize, planSize),
                                painter: painter,
                              )),
                          metricPlan('0 cm', 'X'),
                          options(isWall),
                          Row(
                            children: <Widget>[
                              titleGeneric('Inicial:'),
                              txtGeneric("x", controllerStartX, _nodeText1),
                              txtGeneric("y", controllerStartY, _nodeText2),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              titleGeneric('Final:'),
                              txtGeneric("x", controllerFinishX, _nodeText3),
                              txtGeneric("y", controllerFinishY, _nodeText4),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              titleGeneric('Altura:'),
                              txtGeneric("cm", controllerHeight, _nodeText5),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              )
                            ],
                          ),
                          buttonAdd('Adicionar', Colors.purple, Colors.white,
                              () {
                            // bloc.loadingAddWallStreamController.add(false);

                            if (controllerFinishX.text.isEmpty ||
                                controllerFinishY.text.isEmpty ||
                                controllerHeight.text.isEmpty ||
                                controllerStartX.text == "" ||
                                controllerStartY == "") {
                              _showDialog(
                                  "Atenção", "Preencha todos os campos");
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());

                            this.addLine(this.isWall);
                          }),
                          streamButtonModal(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            bloc.setAllWallsRoom(room, doors, painter.pointers);
                          }),
                          SizedBox(
                            height: 30,
                          )
                        ]))))))
          ],
        ));
  }

  Widget options(isHot) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 20,
                )),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      this.isWall = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    color: !isHot ? null : Colors.purple,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Text(
                      "Paredes",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      this.isWall = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    color: isHot ? null : Colors.purple,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Text(
                      "Portas",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 20,
                )),
          ],
        ));
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

  Widget metricPlan(left, right) {
    return Container(
        margin: EdgeInsets.only(top: 3, bottom: 3, left: 25, right: 25),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    child: Text(
                  left,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
            Expanded(
                flex: 1,
                child: Container(
                    child: Text(
                  right,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ))),
          ],
        ));
  }

  Widget metricPlanRefactor(function, right) {
    return Container(
        margin: EdgeInsets.only(top: 3, bottom: 3, left: 0, right: 25),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Text(
                      right,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
            InkWell(
                onTap: () {
                  function();
                },
                child: Container(
                  alignment: Alignment.topRight,
                  margin:
                      EdgeInsets.only(left: 40, right: 16, top: 0, bottom: 0),
                  child: Icon(
                    Icons.backspace,
                    color: HexColor("#FFFFFF"),
                    size: 25,
                  ),
                )),
          ],
        ));
  }

  Widget titleGeneric(title) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 25, right: 5),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget txtGeneric(name, controller, focus) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: TextField(
            focusNode: focus,
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 22),
              hintText: name,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ));
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

  Widget streamButtonModal(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingAddWallStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return progressModal(10, 10);
          }
          return buttonAdd(
              'Salvar Cômodo', Colors.white, Colors.purple, function);
        });
  }
}

class MyPainter extends CustomPainter {
  RoomProject room = RoomProject();
  RoomProject doors = RoomProject();
  List<Point> pointers = [];

  double proportional = 1;
  double planSize = 1;
  @override
  void paint(Canvas canvas, Size size) {
    // if (room.lines == null || room.lines.length == 0) {
    //   return;
    // }
    //addlinw swem parametr

    room.lines.forEach((element) {
      var ix = element.pointStart.x;
      var iy = element.pointStart.y;
      var fx = element.pointFinish.x;
      var fy = element.pointFinish.y;
      room.lines.forEach((element2) {
        if (element != element2) {
          if ((element2.pointStart.x == ix && element2.pointStart.y == iy)) {
            var f = true;
            pointers.forEach((point) {
              if (point.x == ix && point.y == iy) {
                f = false;
              }
            });
            if (f) {
              pointers.add(Point(ix, iy));
              pointers.add(Point(ix, iy));
            }
          }

          if ((element2.pointStart.x == fx && element2.pointStart.y == fy)) {
            var f = true;
            pointers.forEach((point) {
              if (point.x == fx && point.y == fy) {
                f = false;
              }
            });
            if (f) {
              pointers.add(Point(fx, fy));
              pointers.add(Point(fx, fy));
            }
          }

          if ((element2.pointFinish.x == ix && element2.pointFinish.y == iy)) {
            var f = true;
            pointers.forEach((point) {
              if (point.x == ix && point.y == iy) {
                f = false;
              }
            });
            if (f) {
              pointers.add(Point(ix, iy));
              pointers.add(Point(ix, iy));
            }
          }

          if ((element2.pointFinish.x == fx && element2.pointFinish.y == fy)) {
            var f = true;
            pointers.forEach((point) {
              if (point.x == fx && point.y == fy) {
                f = false;
              }
            });
            if (f) {
              pointers.add(Point(fx, fy));
              pointers.add(Point(fx, fy));
            }
          }
        }
      });
    });

    room.lines.forEach((element) {
      final p1 = element.pointStart.formatterCanvas(proportional, planSize);
      final p2 = element.pointFinish.formatterCanvas(proportional, planSize);
      final paint = Paint()
        ..color = Colors.white
        ..strokeWidth = 4;
      canvas.drawLine(p1, p2, paint);
    });

    doors.lines.forEach((element) {
      final p1 = element.pointStart.formatterCanvas(proportional, planSize);
      final p2 = element.pointFinish.formatterCanvas(proportional, planSize);
      final paint = Paint()
        ..color = Colors.brown
        ..strokeWidth = 8;
      canvas.drawLine(p1, p2, paint);
    });

    pointers.forEach((element) {
      final p1 = element.formatterCanvas(proportional, planSize);
      final paint = Paint()
        ..color = Colors.white
        ..strokeWidth = 15;
      final offset = Offset(p1.dx, p1.dy);
      canvas.drawPoints(ui.PointMode.points, [offset], paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
