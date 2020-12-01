import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ultravmobile/model/point.dart';
import 'package:ultravmobile/screens/project/props_list_tubes.dart';
import 'package:ultravmobile/screens/project/props_list_vertices.dart';
import 'package:ultravmobile/screens/project/props_list_walls.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io' as io;
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';

//Página de planta Baixa

class MyAppDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBarGeneral(back: true),
      body: PlanDownPage(),
    );
  }
}

class PlanDownPage extends StatefulWidget {
  PlanDownPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PlanDownPage createState() => _PlanDownPage();
}

class _PlanDownPage extends State<PlanDownPage> {
  var bloc = BlocProvider.getBloc<BlocPlan>();
  Room room = Room();
  Room room2 = Room();
  int type = 0;
  List<int> numberWalls = [];
  MyPainter painter = MyPainter();
  MyPainter painter2 = MyPainter();
  List<Point> pointers = [];
  double x = 0;
  double y = 0;
  double planSize = 300;
  double planCm = 600;
  List<String> categoriasRooms = <String>[];
  int filtroRoom = 0;
  String dropdowTubeRoom = '';
  String selectWall = null;
  String selectVertex = null;

  var controllerStartX = new TextEditingController();
  var controllerStartY = new TextEditingController();
  var controllerFinishX = new TextEditingController();
  var controllerFinishY = new TextEditingController();

  @override
  void initState() {
    super.initState();
    planSize = 0;
    planCm = bloc.selectPlan.scale;
    initPlanDown();
  }

  Function changeWallselect(String index) {
    print("WallSelect");
    print(index);
    setState(() {
      painter.selectWall = index;
      painter.room.lines = [];
      painter.selectVertex = null;
    });
  }

  Function changeVertexselect(String index) {
    setState(() {
      painter.selectWall = null;
      painter.selectVertex = index;
      painter.pointers = [];
      painter.room.lines = [];
    });
  }

  void initPlanDown() {
    List<String> h = [];

    bloc.selectPlan.rooms.forEach((element) => {h.add(element.name)});
    setState(() {
      categoriasRooms = h;
      dropdowTubeRoom = h.first;
    });
  }

  void addVertices({incrementX, incrementY}) {
    bloc.selectPlan.rooms.forEach((element2) => {
          element2.vertices == null
              ? null
              : element2.vertices.forEach((element) => {
                    pointers.add(Point(double.parse(element.coordX.toString()),
                        double.parse(element.coordY.toString()),
                        id: element.id))
                  })
        });
    setState(() {
      painter.pointers = pointers;
    });
  }

  void addRoom({incrementX, incrementY}) {
    bloc.selectPlan.rooms.forEach((element2) => {
          element2.walls
              .where((f) => f.wallType == 1)
              .toList()
              .forEach((element) => {
                    addLine(
                        pointIniX: double.parse(element.initialX.toString()),
                        pointIniY: double.parse(element.initialY.toString()),
                        pointFinishX: double.parse(element.finalX.toString()),
                        pointFinishY: double.parse(element.finalY.toString()),
                        id: element.id)
                  })
        });

    bloc.selectPlan.rooms.forEach((element2) => {
          element2.walls
              .where((f) => f.wallType == 2)
              .toList()
              .forEach((element) => {
                    addLine(
                        pointIniX: double.parse(element.initialX.toString()),
                        pointIniY: double.parse(element.initialY.toString()),
                        pointFinishX: double.parse(element.finalX.toString()),
                        pointFinishY: double.parse(element.finalY.toString()),
                        color: Colors.brown,
                        id: element.id),
                  })
        });
  }

  void deleteRoom() {}

  void initScreen() {
    setState(() {
      planSize = MediaQuery.of(context).size.width - 50;
    });
  }

  void addLine({pointIniX, pointIniY, pointFinishX, pointFinishY, color, id}) {
    Point pointStart = Point(pointIniX ?? double.parse(controllerStartX.text),
        pointIniY ?? double.parse(controllerStartY.text));
    Point pointFinish = Point(
        pointFinishX ?? double.parse(controllerFinishX.text),
        pointFinishY ?? double.parse(controllerFinishY.text));
    var colorFini = color ?? Colors.white;
    setState(() {
      planSize = MediaQuery.of(context).size.width - 80;
      room.lines.add(Line(pointStart, pointFinish, color: colorFini, id: id));
      painter.proportional = planSize / planCm;
      painter.planSize = planSize;
      painter.room = room;
      controllerStartX.text = controllerFinishX.text;
      controllerStartY.text = controllerFinishY.text;
      controllerFinishX.text = '';
      controllerFinishY.text = '';
    });
  }

  void addLine2({pointIniX, pointIniY, pointFinishX, pointFinishY}) {
    Point pointStart = Point(pointIniX ?? double.parse(controllerStartX.text),
        pointIniY ?? double.parse(controllerStartY.text));
    Point pointFinish = Point(
        pointFinishX ?? double.parse(controllerFinishX.text),
        pointFinishY ?? double.parse(controllerFinishY.text));
    setState(() {
      planSize = MediaQuery.of(context).size.width - 80;
      room2.lines.add(Line(pointStart, pointFinish));
      painter2.proportional = planSize / planCm;
      painter2.planSize = planSize;
      painter2.room = room;
    });
  }

  void deleteLastLine() {
    for (int i = 0; i < numberWalls.last; i++) {
      setState(() {
        room.lines..removeLast();
        painter.room = room;
      });
    }
    setState(() {
      numberWalls.removeLast();
    });
  }

  takescrshot() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData.buffer.asUint8List();
    setState(() {
      pngBytes = byteData.buffer.asUint8List();
    });
    pdfCreate();
    print(pngBytes);
  }

  var pngBytes;
  var scr = new GlobalKey();
  final pdf = pw.Document();

  void pdfCreate() async {
    final image = PdfImage.file(
      pdf.document,
      bytes: pngBytes,
    );

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Container(
          color: PdfColors.black,
          child: pw.Column(
              children: [pw.Image(image), pw.Text("ssssssss")])); // Center
    }));
    Directory documents = await getApplicationDocumentsDirectory();

    await io.File("${documents.path}/example.pdf").writeAsBytesSync(pdf.save());

    final MailOptions mailOptions = MailOptions(
      body: 'a long body for the email <br> with a subset of HTML',
      subject: 'the Email Subject',
      recipients: ['example@example.com'],
      isHTML: true,
      bccRecipients: ['other@example.com'],
      ccRecipients: ['third@example.com'],
      attachments: [
        "${documents.path}/example.pdf",
      ],
    );

    await FlutterMailer.send(mailOptions);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    addRoom();
    addVertices();
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
            placeGeneral('Planta Baixa Vista Superior'),
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              pngBytes != null ? Image.memory(pngBytes) : Container(),
              // InkWell(
              //     onTap: () {
              //       takescrshot();
              //     },
              //     child: Container(child: Text("isjijsijs"))),
              metricPlanRefactor(this.deleteLastLine, '$planCm cm'),
              // RepaintBoundary(
              //     key: scr,
              //     child:
              Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: CustomPaint(
                        size: Size(planSize, planSize),
                        painter: painter,
                      )))
              //)
              ,
              metricPlan('0 cm', '$planCm  cm'),
              // buttonAdd('Adicionar Cômodo', Colors.deepOrangeAccent,
              //     Colors.white, this.addRoomsList),
              SizedBox(
                height: 0,
              ),
              Row(
                children: <Widget>[
                  txtGeneric("y", controllerStartY),
                ],
              ),

              // InkWell(
              //     onTap: () {
              //       // addRoomMt(incrementX: 0.0, incrementY: 200.0);
              //       //     addCookMt(incrementX: 0.0, incrementY: 0.0);
              //       addOfficeMt(incrementX: 0.0, incrementY: 200.0);
              //     },
              //     child: Container(
              //         color: Colors.white,
              //         width: MediaQuery.of(context).size.width,
              //         margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              //         padding: EdgeInsets.only(
              //             left: 16, right: 16, top: 10, bottom: 10),
              //         child: Row(
              //           children: <Widget>[
              //             Container(
              //                 margin: EdgeInsets.only(right: 30),
              //                 child: Text("Escritório")),
              //             txtGeneric("x", controllerStartX),
              //             txtGeneric("y", controllerStartY),
              //             Container(
              //                 color: Colors.orange,
              //                 margin: EdgeInsets.only(right: 30),
              //                 padding: EdgeInsets.all(10),
              //                 child: Text("Add")),
              //           ],
              //         ))),

              // InkWell(
              //     onTap: () {
              //       addRoomMt(incrementX: 0.0, incrementY: 200.0);
              //       //     addCookMt(incrementX: 0.0, incrementY: 0.0);
              //       // addOfficeMt(incrementX: 0.0, incrementY: 200.0);
              //     },
              //     child: Container(
              //         color: Colors.white,
              //         width: MediaQuery.of(context).size.width,
              //         margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              //         padding: EdgeInsets.only(
              //             left: 16, right: 16, top: 10, bottom: 10),
              //         child: Row(
              //           children: <Widget>[
              //             Container(
              //                 margin: EdgeInsets.only(right: 30),
              //                 child: Text("Sala de Estar")),
              //             txtGeneric("x", controllerStartX),
              //             txtGeneric("y", controllerStartY),
              //             Container(
              //                 color: Colors.orange,
              //                 margin: EdgeInsets.only(right: 30),
              //                 padding: EdgeInsets.all(10),
              //                 child: Text("Add")),
              //           ],
              //         ))),

              // InkWell(
              //     onTap: () {
              //       //addRoomMt(incrementX: 0.0, incrementY: 200.0);
              //       addCookMt(incrementX: 0.0, incrementY: 0.0);
              //       // addOfficeMt(incrementX: 0.0, incrementY: 200.0);
              //     },
              //     child: Container(
              //         color: Colors.white,
              //         width: MediaQuery.of(context).size.width,
              //         margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              //         padding: EdgeInsets.only(
              //             left: 16, right: 16, top: 10, bottom: 10),
              //         child: Row(
              //           children: <Widget>[
              //             Container(
              //                 margin: EdgeInsets.only(right: 30),
              //                 child: Text("Cozinha")),
              //             txtGeneric("x", controllerStartX),
              //             txtGeneric("y", controllerStartY),
              //             Container(
              //                 color: Colors.orange,
              //                 margin: EdgeInsets.only(right: 30),
              //                 padding: EdgeInsets.all(10),
              //                 child: Text("Add")),
              //           ],
              //         ))),

              Card(
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  color: Colors.cyan,
                  child: DropdownButton<String>(
                    value: dropdowTubeRoom,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdowTubeRoom = newValue;
                        filtroRoom = categoriasRooms.indexOf(newValue);
                      });
                    },
                    items: categoriasRooms
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 90,
                            child: Text(value)),
                      );
                    }).toList(),
                  )),

              optionsIcon(type),

              this.type == 0
                  ? (Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: PropsListWallCell(
                          bloc.selectPlan.rooms[filtroRoom].walls,
                          changeWallselect,
                          painter.selectWall)))
                  : (Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: PropsListVertexCell(
                          bloc.selectPlan.rooms[filtroRoom].vertices,
                          changeVertexselect,
                          painter.selectVertex))),
            ]))))
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
                        painter.selectVertex = null;
                        painter.selectWall = null;
                      });
                    },
                    child: Icon(
                      Icons.border_style,
                      color: type == 0 ? Colors.purple : Colors.white,
                      size: 28,
                    ))),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        this.type = 1;
                        painter.selectVertex = null;
                        painter.selectWall = null;
                      });
                    },
                    child: Icon(
                      Icons.center_focus_strong,
                      color: type == 1 ? Colors.purple : Colors.white,
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
                    child: Text(left,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)))),
            Expanded(
                flex: 1,
                child: Container(
                    child: Text(right,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white)))),
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
                    child: Text(
                  right,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white),
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
      child: TextField(
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 14),
          hintText: name,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
      ),
    );
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

  void roomsAddDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Modal insert rooms")],
                ),
              ),
            ),
          );
        });
  }
}

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  Room room = Room();
  List<Point> pointers = [];
  double proportional = 1;
  double planSize = 1;
  String selectWall = null;
  String selectVertex = null;
  @override
  void paint(Canvas canvas, Size size) {
    if (room.lines == null || room.lines.length == 0) {
      return;
    }
    var i = 0;
    var x = 0;

    room.lines.forEach((element) {
      if (selectWall != element.id) {
        final p1 = element.pointStart.formatterCanvas(proportional, planSize);
        final p2 = element.pointFinish.formatterCanvas(proportional, planSize);
        final paint = Paint()
          ..color = element.color ?? Colors.white
          ..strokeWidth = 4;
        canvas.drawLine(p1, p2, paint);
        final textStyle = TextStyle(
          color: selectWall == i ? Colors.red : Colors.white,
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
        i++;
      }
    });

    room.lines.forEach((element) {
      if (selectWall == element.id) {
        final p1 = element.pointStart.formatterCanvas(proportional, planSize);
        final p2 = element.pointFinish.formatterCanvas(proportional, planSize);
        final paint = Paint()
          ..color = Colors.red
          ..strokeWidth = 4;
        canvas.drawLine(p1, p2, paint);
        final textStyle = TextStyle(
          color: Colors.red,
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
        i++;
      }
    });

    pointers.forEach((element) {
      if (selectVertex != element.id) {
        final p1 = element.formatterCanvas(proportional, planSize);
        final paint = Paint()
          ..color = Colors.white
          ..strokeWidth = 15;
        final offset = Offset(p1.dx, p1.dy);
        canvas.drawPoints(ui.PointMode.points, [offset], paint);
        x++;
      }
    });
    pointers.forEach((element) {
      if (selectVertex == element.id) {
        final p1 = element.formatterCanvas(proportional, planSize);
        final paint = Paint()
          ..color = Colors.red
          ..strokeWidth = 15;
        final offset = Offset(p1.dx, p1.dy);
        canvas.drawPoints(ui.PointMode.points, [offset], paint);
        x++;
      }
    });

    x = 0;
    i = 0;
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
