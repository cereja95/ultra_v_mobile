import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ultravmobile/model/point.dart';
import 'package:ultravmobile/screens/prototype/tube_preview.dart';
import 'package:ultravmobile/screens/prototype/tube_prototype.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import 'dart:math';

class WallPrototypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBarGeneral(back: true),
      body: WallPrototypePage(),
    );
  }
}

class WallPrototypePage extends StatefulWidget {
  WallPrototypePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WallPrototypePage createState() => _WallPrototypePage();
}

class _WallPrototypePage extends State<WallPrototypePage> {
  Room room = Room();
  MyPainter painter = MyPainter();
  double x = 0;
  double y = 0;
  double planSize = 300;
  double planCm = 700;
  List<Point> pointers = [];

  var controllerStartX = new TextEditingController();
  var controllerStartY = new TextEditingController();
  var controllerFinishX = new TextEditingController();
  var controllerFinishY = new TextEditingController();

  var bloc = BlocProvider.getBloc<BlocPlan>();
  int minY = 0;
  int maxY = 0;
  int minX = 0;
  int maxX = 0;
  @override
  void initState() {
    super.initState();
    planSize = 0;
    planCm = bloc.calcPlanX() > bloc.calcPlanY()
        ? bloc.calcPlanX()
        : bloc.calcPlanY();
    //planCm = bloc.selectPlan.scale;
    // newPlanSize();
  }

  void newPlanSize() {
    List<int> y = [];
    List<int> x = [];
    bloc.selectRoom.walls.forEach((element) => {
          x.add(element.finalX),
          x.add(element.initialX),
          y.add(element.finalY),
          y.add(element.initialY),
        });
    setState(() {
      minY = y.reduce(min);
      maxY = y.reduce(max);
      minX = x.reduce(min);
      maxX = x.reduce(max);

      var maxx = (maxY - minY) < 0 ? (maxY - minY) * (-1) : (maxY - minY);
      var maxx2 = (maxX - minX) < 0 ? (maxX - minX) * (-1) : (maxX - minX);

      planCm = maxx > maxx2
          ? double.parse((maxx + 50.0).toString())
          : double.parse((maxx2 + 50.0).toString());
    });
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
    bloc.selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              element.id != bloc.selectWall.id
                  ? addLine(
                      pointIniX: double.parse(element.initialX.toString()) +
                          incrementX,
                      pointIniY: double.parse(element.initialY.toString()) +
                          incrementY,
                      pointFinishX:
                          double.parse(element.finalX.toString()) + incrementX,
                      pointFinishY:
                          double.parse(element.finalY.toString()) + incrementY,
                      color: Colors.white)
                  : null
            });

    bloc.selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              element.id == bloc.selectWall.id
                  ? addLine(
                      pointIniX: double.parse(element.initialX.toString()) +
                          incrementX,
                      pointIniY: double.parse(element.initialY.toString()) +
                          incrementY,
                      pointFinishX:
                          double.parse(element.finalX.toString()) + incrementX,
                      pointFinishY:
                          double.parse(element.finalY.toString()) + incrementY,
                      color: Colors.red)
                  : null
            });

    bloc.selectRoom.walls
        .where((f) => f.wallType == 2)
        .toList()
        .forEach((element) => {
              addLine(
                pointIniX: double.parse(element.initialX.toString()),
                pointIniY: double.parse(element.initialY.toString()),
                pointFinishX: double.parse(element.finalX.toString()),
                pointFinishY: double.parse(element.finalY.toString()),
                color: Colors.brown,
              )
            });

    // addLine(
    //     pointIniX: (0 + incrementX),
    //     pointIniY: 0 + incrementY,
    //     pointFinishX: 500 + incrementX,
    //     pointFinishY: 0 + incrementY);
    // addLine(
    //     pointIniX: (500 + incrementX),
    //     pointIniY: 0 + incrementY,
    //     pointFinishX: 500 + incrementX,
    //     pointFinishY: 200 + incrementY);
    // addLine(
    //     pointIniX: (500 + incrementX),
    //     pointIniY: 200 + incrementY,
    //     pointFinishX: 0 + incrementX,
    //     pointFinishY: 200 + incrementY,
    //     color: Colors.red);

    // addLine(
    //     pointIniX: (0 + incrementX),
    //     pointIniY: 200 + incrementY,
    //     pointFinishX: 0 + incrementX,
    //     pointFinishY: 0 + incrementY);
  }

  @override
  Widget build(BuildContext context) {
    planSize = MediaQuery.of(context).size.width - 80;
    addRoom(incrementX: -bloc.calcPlanMinX(), incrementY: -bloc.calcPlanMinY());
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
              _cellProduct(bloc.selectWall),
              bloc.selectWall.tubes.length != 0
                  ? buttonAdd(
                      'Visualizar Tubulação', Colors.white, Colors.purple, () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => TubePreview()));
                    })
                  : Container(),
              buttonAdd('Inserir Tubulação', Colors.purple, Colors.white, () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TubePrototypeScreen()));
              }),
              SizedBox(
                height: 30,
              )
            ]))))
          ],
        ));
  }

  Widget _cellProduct(product) {
    return new InkWell(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 15),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                child: Text("Parede",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Lao Sangam MN"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(),
                          child: Text("Coordenadas:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                              "(" +
                                  product.initialX.toString() +
                                  ", " +
                                  product.initialY.toString() +
                                  ") - (" +
                                  product.finalX.toString() +
                                  ", " +
                                  product.finalY.toString() +
                                  ")",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: HexColor('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                    ],
                  )),
              Container(
                  alignment: Alignment.topLeft,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(),
                          child: Text("Tamanho:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                              hipotenusa(product.finalX, product.finalY,
                                          product.initialX, product.initialY)
                                      .toStringAsFixed(2) +
                                  " cm",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: HexColor('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                    ],
                  )),
              Container(
                  alignment: Alignment.topLeft,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(),
                          child: Text("Altura:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                      Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text("${product.height} cm",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: HexColor('#333333'),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1)),
                    ],
                  )),
            ],
          ),
        ));
  }
}

double hipotenusa(finalX, finalY, initialX, initialY) {
  return pow(
      pow(double.parse((finalX - initialX).toString()), 2) +
          pow(double.parse((finalY - initialY).toString()), 2),
      1 / 2);
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
    });
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
