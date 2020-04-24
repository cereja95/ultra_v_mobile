import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import 'dart:math';
import 'package:keyboard_actions/keyboard_actions.dart';

class TubePrototypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBarGeneral(back: true),
      body: TubePrototypePage(),
    );
  }
}

class TubePrototypePage extends StatefulWidget {
  TubePrototypePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TubePrototypePage createState() => _TubePrototypePage();
}

class _TubePrototypePage extends State<TubePrototypePage> {
  RoomProject room = RoomProject();
  List<int> removeType = [];
  List<Point> pointers = [];
  MyPainter painter = MyPainter();
  int type = 0;
  double x = 0;
  double y = 0;
  double planSize = 300;
  double planCm = 300;
  bool isHot = true;
  var bloc = BlocProvider.getBloc<BlocPlan>();
  var controllerStartX = new TextEditingController();
  var controllerStartY = new TextEditingController();
  var controllerFinishX = new TextEditingController();
  var controllerFinishY = new TextEditingController();
  var controllerJunX = new TextEditingController();
  var controllerJunY = new TextEditingController();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();

  @override
  void initState() {
    super.initState();
    planSize = 0;
    var hip = hipotenusa(bloc.selectWall.finalX, bloc.selectWall.finalY,
        bloc.selectWall.initialX, bloc.selectWall.initialY);
    planCm = hip > bloc.selectWall.height
        ? hip.roundToDouble()
        : bloc.selectWall.height.toDouble();
    bloc.alertTube = _showDialogg;
    //  SchedulerBinding.instance
    //    .addPostFrameCallback((_) => this.roomsAddDialog(context));
    //   this._showDialog("Tutorial", "Posicione-se de frente para a parede"));
  }

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
      ],
    );
  }

  double hipotenusa(finalX, finalY, initialX, initialY) {
    return pow(
        pow(double.parse((finalX - initialX).toString()), 2) +
            pow(double.parse((finalY - initialY).toString()), 2),
        1 / 2);
  }

  void _showDialogg(
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initScreen() {
    setState(() {
      planSize = MediaQuery.of(context).size.width - 50;
    });
  }

  void addLine() {
    Point pointStart = Point(double.parse(controllerStartX.text),
        double.parse(controllerStartY.text));
    Point pointFinish = Point(double.parse(controllerFinishX.text),
        double.parse(controllerFinishY.text));
    setState(() {
      planSize = MediaQuery.of(context).size.width - 80;
      removeType.add(0);
      painter.type = type;
      room.lines.add(Line(pointStart, pointFinish,
          color: (type == 0 ? Colors.red : Colors.lightBlueAccent)));
      painter.proportional = planSize / planCm;
      painter.planSize = planSize;
      painter.room = room;
      controllerStartX.text = controllerFinishX.text;
      controllerStartY.text = controllerFinishY.text;
      controllerFinishX.text = '';
      controllerFinishY.text = '';
    });
  }

  void addPointer() {
    if (controllerJunX.text.isEmpty || controllerJunY.text.isEmpty) {
      _showDialog("Atenção", "Preencha todos os campos");
      return;
    }
    Point pointStart = Point(
        double.parse(controllerJunX.text), double.parse(controllerJunY.text));
    setState(() {
      planSize = MediaQuery.of(context).size.width - 80;
      pointers.add(pointStart);
      removeType.add(1);
      painter.type = type;
      painter.proportional = planSize / planCm;
      painter.planSize = planSize;
      painter.pointers = pointers;
      controllerJunX.text = '';
      controllerJunY.text = '';
    });
  }

  void deleteLastLine() {
    if (removeType.last == 0) {
      setState(() {
        removeType.removeLast();
        room.lines..removeLast();
        painter.room = room;
      });
    } else {
      setState(() {
        removeType.removeLast();
        pointers..removeLast();
        painter.room = room;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    planSize = MediaQuery.of(context).size.width - 80;
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
            placeGeneral('Tubulação da ' + bloc.selectWall.name),
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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          metricPlanRefactor(deleteLastLine, 'Y'),
                          Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              child: CustomPaint(
                                size: Size(planSize, planSize),
                                painter: painter,
                              )),
                          metricPlan('0 cm', 'X'),
                          optionsIcon(type),
                          Container(
                            color: Colors.white,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: this.type != 2
                                ? Column(children: <Widget>[
                                    titleOptions(type),
                                    Row(
                                      children: <Widget>[
                                        titleGeneric('Ponto inicial'),
                                        txtGeneric(
                                            "X", controllerStartX, _nodeText1),
                                        txtGeneric(
                                            "Y", controllerStartY, _nodeText2),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        titleGeneric('Ponto final'),
                                        txtGeneric(
                                            "X", controllerFinishX, _nodeText3),
                                        txtGeneric(
                                            "Y", controllerFinishY, _nodeText4),
                                      ],
                                    ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     titleGeneric('Seção:'),
                                    //     txtGenericSize("Ex: 20cm", null),
                                    //     Expanded(flex: 1, child: SizedBox())
                                    //   ],
                                    // ),
                                  ])
                                : Column(children: <Widget>[
                                    titleOptions(type),
                                    // Container(
                                    //     margin: EdgeInsets.only(left: 20, top: 10),
                                    //     alignment: Alignment.topLeft,
                                    //     child: Text(
                                    //       "Tipo",
                                    //       textAlign: TextAlign.start,
                                    //       style: TextStyle(fontSize: 15),
                                    //     )),
                                    Card(
                                        margin: EdgeInsets.only(
                                            bottom: 10, left: 10, right: 10),
                                        color: Colors.cyan,
                                        child: DropdownButton<String>(
                                          value: bloc.dropdowTubeConnect,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              bloc.dropdowTubeConnect =
                                                  newValue;
                                              bloc.filtroConnect = bloc
                                                  .categoriasConnect
                                                  .indexOf(newValue);
                                            });
                                          },
                                          items: bloc.categoriasConnect
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90,
                                                  child: Text(value)),
                                            );
                                          }).toList(),
                                        )),

                                    Row(
                                      children: <Widget>[
                                        titleGeneric('Ponto'),
                                        txtGeneric(
                                            "X", controllerJunX, _nodeText3),
                                        txtGeneric(
                                            "Y", controllerJunY, _nodeText4),
                                      ],
                                    ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     titleGeneric('Seção:'),
                                    //     txtGeneric("Ex: 20cm", null),
                                    //     Expanded(flex: 1, child: SizedBox())
                                    //   ],
                                    // ),

                                    // Row(
                                    //   children: <Widget>[
                                    //     titleGeneric('Tipo:'),
                                    //     txtGeneric("Ex: 1", null),
                                    //     Expanded(
                                    //         flex: 1,
                                    //         child: SizedBox(
                                    //           width: 100,
                                    //         ))
                                    //   ],
                                    // ),
                                  ]),
                          ),
                          this.type == 2
                              ? buttonAdd('Adicionar Junção', Colors.purple,
                                  Colors.white, () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  this.addPointer();
                                })
                              : buttonAdd(
                                  'Adicionar Tubo', Colors.purple, Colors.white,
                                  () {
                                  if (controllerFinishX.text.isEmpty ||
                                      controllerFinishY.text.isEmpty ||
                                      controllerStartX.text == "" ||
                                      controllerStartY == "") {
                                    _showDialog(
                                        "Atenção", "Preencha todos os campos");
                                    return;
                                  }
                                  this.addLine();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }),
                          streamButtonModal(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            bloc.setAllTubesWall(room, pointers);
                          }),
                          SizedBox(
                            height: 30,
                          )
                        ])))))),
          ],
        ));
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
        stream: bloc.loadingAddTubeStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return progressModal(10, 10);
          }
          return buttonAdd(
              'Salvar Tubulação', Colors.white, Colors.purple, function);
        });
  }

  void _showDialog(
    title,
    describe,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(describe),
          actions: <Widget>[
            // define os botões na base do dialogo
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

  void roomsAddDialog(context) {
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
                    Text(
                      "Junção",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    txtGenericModal("X", controllerJunX),
                    txtGenericModal("Y", controllerJunY),
                    buttonAdd('Adicionar Junção', Colors.purple, Colors.white,
                        this.addPointer),
                  ],
                ),
              ),
            ),
          );
        });
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
                      this.isHot = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    color: !isHot ? null : Colors.orange,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Text(
                      "Tubos Quentes",
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
                      this.isHot = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    color: isHot ? null : Colors.orange,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Text(
                      "Tubos Frios",
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

  Widget optionsIcon(type) {
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
                        this.type = 0;
                      });
                    },
                    child: Icon(
                      Icons.hot_tub,
                      color: type == 0 ? Colors.purple : Colors.white,
                      size: 28,
                    ))),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        this.type = 1;
                      });
                    },
                    child: Icon(
                      Icons.branding_watermark,
                      color: type == 1 ? Colors.purple : Colors.white,
                      size: 28,
                    ))),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        this.type = 2;
                      });
                    },
                    child: Icon(
                      Icons.queue,
                      color: type == 2 ? Colors.purple : Colors.white,
                      size: 28,
                    ))),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 20,
                )),
          ],
        ));
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
                margin: EdgeInsets.only(left: 40, right: 16, top: 0, bottom: 0),
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
        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 17),
          textAlign: TextAlign.center,
        ),
      ));
}

Widget titleOptions(type) {
  var title = "";
  if (type == 0) {
    title = "Tubos Quentes";
  }

  if (type == 1) {
    title = "Tubos Frios";
  }

  if (type == 2) {
    title = "Junções";
  }

  return Container(
    margin: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 12),
    child: Text(
      title,
      style: TextStyle(color: Colors.black, fontSize: 17),
      textAlign: TextAlign.center,
    ),
  );
}

Widget txtGeneric(name, controller, focus) {
  return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 1, right: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.grey),
        ),
        child: TextField(
          focusNode: focus,
          keyboardType: TextInputType.number,
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

Widget txtGenericSize(name, controller) {
  return Expanded(
      child: Container(
    margin: EdgeInsets.only(top: 15, left: 1, right: 15, bottom: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      border: Border.all(color: Colors.grey),
    ),
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

Widget txtGenericModal(name, controller) {
  return Expanded(
      child: Container(
    margin: EdgeInsets.only(top: 15, left: 1, right: 15, bottom: 15),
    decoration: BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.all(Radius.circular(6)),
      border: Border.all(color: Colors.grey),
    ),
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

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  RoomProject room = RoomProject();
  List<Point> pointers = [];
  int type = 0;
  double proportional = 1;
  double planSize = 1;
  @override
  void paint(Canvas canvas, Size size) {
    // if (room.lines == null || room.lines.length == 0) {
    //   return;
    // }

    room.lines.forEach((element) {
      final p1 = element.pointStart.formatterCanvas(proportional, planSize);
      final p2 = element.pointFinish.formatterCanvas(proportional, planSize);
      final paint = Paint()
        ..color = element.color ?? Colors.black
        ..strokeWidth = 4;
      canvas.drawLine(p1, p2, paint);
    });

    pointers.forEach((element) {
      final p1 = element.formatterCanvas(proportional, planSize);
      final paint = Paint()
        ..color = Colors.grey
        ..strokeWidth = 20;
      final offset = Offset(p1.dx, p1.dy);
      canvas.drawPoints(ui.PointMode.points, [offset], paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
