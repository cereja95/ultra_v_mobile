import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ultravmobile/model/point.dart';
import 'package:ultravmobile/screens/project/props_list_tubes.dart';
import 'package:ultravmobile/screens/prototype/tube_prototype.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import 'dart:math';

class TubePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBarGeneral(back: true),
      body: TubePreviewScreen(),
    );
  }
}

class TubePreviewScreen extends StatefulWidget {
  TubePreviewScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TubePreviewScreen createState() => _TubePreviewScreen();
}

class _TubePreviewScreen extends State<TubePreviewScreen> {
  Room room = Room();
  MyPainter painter = MyPainter();
  double x = 0;
  double y = 0;
  double planSize = 300;
  double planCm = 300;
  List<Point> pointers = [];

  var controllerStartX = new TextEditingController();
  var controllerStartY = new TextEditingController();
  var controllerFinishX = new TextEditingController();
  var controllerFinishY = new TextEditingController();

  var bloc = BlocProvider.getBloc<BlocPlan>();

  @override
  void initState() {
    super.initState();
    planSize = 0;
    var hip = hipotenusa(bloc.selectWall.finalX, bloc.selectWall.finalY,
        bloc.selectWall.initialX, bloc.selectWall.initialY);
    planCm = hip > bloc.selectWall.height
        ? hip.roundToDouble()
        : bloc.selectWall.height.toDouble();
  }

  double hipotenusa(finalX, finalY, initialX, initialY) {
    return pow(
        pow(double.parse((finalX - initialX).toString()), 2) +
            pow(double.parse((finalY - initialY).toString()), 2),
        1 / 2);
  }

  void deleteLastLine() {
    setState(() {
      room.lines..removeLast();
      painter.room = room;
    });
  }

  void initScreen() {
    setState(() {
      planSize = MediaQuery.of(context).size.width - 50;
    });
  }

  void addLine({pointIniX, pointIniY, pointFinishX, pointFinishY, color}) {
    Point pointStart = Point(pointIniX ?? double.parse(controllerStartX.text),
        pointIniY ?? double.parse(controllerStartY.text));
    Point pointFinish = Point(
        pointFinishX ?? double.parse(controllerFinishX.text),
        pointFinishY ?? double.parse(controllerFinishY.text));
    var colorFini = color ?? Colors.white;
    setState(() {
      planSize = MediaQuery.of(context).size.width - 80;
      room.lines.add(Line(pointStart, pointFinish, color: colorFini));
      painter.proportional = planSize / planCm;
      painter.planSize = planSize;
      painter.room = room;
      controllerStartX.text = controllerFinishX.text;
      controllerStartY.text = controllerFinishY.text;
      controllerFinishX.text = '';
      controllerFinishY.text = '';
    });
  }

  void addRoom({incrementX, incrementY}) {
    print(bloc.selectWall.tubes.last.tubeType);

    bloc.selectWall.tubes
        .where((f) => f.tubeType == 1)
        .toList()
        .forEach((element) => {
              addLine(
                  pointIniX: double.parse(element.initialX.toString()),
                  pointIniY: double.parse(element.initialY.toString()),
                  pointFinishX: double.parse(element.finalX.toString()),
                  pointFinishY: double.parse(element.finalY.toString()),
                  color: Colors.red)
            });

    bloc.selectWall.tubes
        .where((f) => f.tubeType == 2)
        .toList()
        .forEach((element) => {
              addLine(
                pointIniX: double.parse(element.initialX.toString()),
                pointIniY: double.parse(element.initialY.toString()),
                pointFinishX: double.parse(element.finalX.toString()),
                pointFinishY: double.parse(element.finalY.toString()),
                color: Colors.lightBlueAccent,
              )
            });

    bloc.selectWall.tubes.forEach((element) => {
          if (element.tubeType > 4)
            {
              addPointer(
                  element.initialX.toString(), element.initialY.toString())
            }
        });
  }

  void addPointer(x, y) {
    Point pointStart = Point(double.parse(x), double.parse(y));
    setState(() {
      pointers.add(pointStart);
      painter.pointers = pointers;
    });
  }

  @override
  Widget build(BuildContext context) {
    planSize = MediaQuery.of(context).size.width - 80;
    addRoom(incrementX: 0.0, incrementY: 0.0);
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
            placeGeneral(bloc.selectWall.name),
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "${planCm} x ${planCm} cm",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              metricPlanRefactor(deleteLastLine, 'Y'),
              Container(
                  padding: EdgeInsets.all(2),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: CustomPaint(
                    size: Size(planSize, planSize),
                    painter: painter,
                  )),
              metricPlan('0 cm', 'X'),
              SizedBox(
                height: 0,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: new FloatingActionButton(
              //       backgroundColor: Colors.purple,
              //       onPressed: () {
              //         planAddDialog(context);
              //         // Navigator.of(context).push(MaterialPageRoute(
              //         //     builder: (BuildContext context) => ProjectRoom()));
              //       },
              //       child: new Icon(
              //         Icons.add,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),

              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: PropsListTubeCell(bloc.selectWall.tubes, () {})),
            ]))))
          ],
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
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: PropsListTubeCell(
                                bloc.selectWall.tubes, () {}))),
                  ],
                ),
              ),
            ),
          );
        });
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

Widget options() {
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
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Icon(
                      Icons.linear_scale,
                      color: Colors.white,
                      size: 25,
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Icon(
                      Icons.exit_to_app,
                      color: HexColor("#FFFFFF"),
                      size: 25,
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    child: Icon(
                      Icons.rounded_corner,
                      color: HexColor("#FFFFFF"),
                      size: 25,
                    ),
                  ))),
          Expanded(
              flex: 1,
              child: SizedBox(
                height: 20,
              )),
        ],
      ));
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ))),
          Expanded(
              flex: 1,
              child: Container(
                  child: Text(right,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )))),
        ],
      ));
}

Widget metricPlanRefactor(function, right) {
  return Container(
      margin: EdgeInsets.only(top: 3, bottom: 3, left: 30, right: 25),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  child: Text(
                right,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ))),
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

Widget txtGeneric(name, controller) {
  return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
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
  Room room = Room();
  double proportional = 1;
  double planSize = 1;
  List<Point> pointers = [];

  @override
  void paint(Canvas canvas, Size size) {
    if (room.lines == null || room.lines.length == 0) {
      return;
    }

    room.lines.forEach((element) {
      final p1 = element.pointStart.formatterCanvas(proportional, planSize);
      final p2 = element.pointFinish.formatterCanvas(proportional, planSize);
      final paint = Paint()
        ..color = element.color ?? Colors.white
        ..strokeWidth = 4;
      canvas.drawLine(p1, p2, paint);
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 10,
      );
      final textSpan = TextSpan(
        text: '30 cm',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      if (p1.dx == p2.dx) {
        // final offset = Offset((p1.dx + p2.dx) / 2 + 3, (p1.dy + p2.dy) / 2);
        //  textPainter.paint(canvas, offset);
      } else {
        //  final offset = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2 + 3);
        // textPainter.paint(canvas, offset);
      }

      pointers.forEach((element) {
        final p1 = element.formatterCanvas(proportional, planSize);
        final paint = Paint()
          ..color = Colors.grey
          ..strokeWidth = 20;
        final offset = Offset(p1.dx, p1.dy);
        canvas.drawPoints(ui.PointMode.points, [offset], paint);
      });
    });
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
