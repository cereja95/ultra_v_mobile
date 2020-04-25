import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ultravmobile/model/point.dart';

import 'package:ultravmobile/screens/project/listProject.dart';
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
import 'dart:math';

//Página de planta Baixa

class MyAppDownPdf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBarGeneral(back: true),
      body: PlanDownPDFPage(),
    );
  }
}

class PlanDownPDFPage extends StatefulWidget {
  PlanDownPDFPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PlanDownPDFPage createState() => _PlanDownPDFPage();
}

class _PlanDownPDFPage extends State<PlanDownPDFPage> {
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
  var isVisible = false;

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
    print("<Catuga>:");
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
    setState(() {
      pointers = [];
    });
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
      isLoad = false;
    });
  }

  void addRoom({incrementX, incrementY}) {
    setState(() {
      room.lines = [];
    });
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

  void showPicture(context, painterTotal) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: RepaintBoundary(
                key: scr,
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: CustomPaint(
                          size: Size(planSize, planSize),
                          painter: painterTotal,
                        ))),
              ));
        });
  }

  String colorString(index) {
    switch (index) {
      case 0:
        {
          return "Azul";
        }
        break;

      case 1:
        {
          return "Vermelho";
        }
        break;

      case 2:
        {
          return "Laranja";
        }
        break;

      case 3:
        {
          return "Amarelo";
        }
        break;

      case 4:
        {
          return "Verde";
        }
        break;

      case 5:
        {
          return "Marrom";
        }
        break;

      case 6:
        {
          return "Roxo";
        }
        break;

      case 6:
        {
          return "Verde Água";
        }
        break;

      case 6:
        {
          return "Preto";
        }
        break;

      case 6:
        {
          return "Rosa";
        }
        break;

      default:
        {
          return "Verde Teal";
        }
        break;
    }
  }

  Color color(index) {
    switch (index) {
      case 0:
        {
          return Colors.blue;
        }
        break;

      case 1:
        {
          return Colors.red;
        }
        break;

      case 2:
        {
          return Colors.orange;
        }
        break;

      case 3:
        {
          return Colors.yellow.shade600;
        }
        break;

      case 4:
        {
          return Colors.green;
        }
        break;

      case 5:
        {
          return Colors.brown;
        }
        break;

      case 6:
        {
          return Colors.purple;
        }
        break;

      case 6:
        {
          return Colors.cyan;
        }
        break;

      case 6:
        {
          return Colors.black;
        }
        break;

      case 6:
        {
          return Colors.pink;
        }
        break;

      default:
        {
          return Colors.teal;
        }
        break;
    }
  }

  var i = 0;
  var j = 0;
  takescrshot() async {
    setState(() {
      painter.selectWall = null;
      painter.selectVertex = null;
      isVisible = true;
      i = 0;
      j = 0;
    });
    MyPainter p = MyPainter();
    p.room = Room();
    p.room.lines = [];
    painter.room.lines.forEach((element) => {p.room.lines.add(element)});

    p.pointers = painter.pointers;
    p.proportional = painter.proportional;
    p.planSize = painter.planSize;
    p.selectWall = null;
    p.selectVertex = null;
    p.room.lines
        .forEach((element) => {element.color = color(i), i++, print(i)});

    p.pointers.forEach((element) => {element.color = color(j), j++, print(j)});
    setState(() {
      painter2 = p;
    });

    // await showPicture(context, p);
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = await byteData.buffer.asUint8List();

    setState(() {
      pngBytes = byteData.buffer.asUint8List();
    });
    pdfCreate();
    print(pngBytes);
  }

  pw.Widget createPagesRoomsPdf(context) {
    var m = 0;
    List<pw.Widget> list = new List();
    list.add(pw.Text("hi"));
    list.add(pw.Text("hi2"));
    list.add(pw.Text("hi3"));

    bloc.selectPlan.rooms.forEach(
        (element) => {list.add(createPageRoomPdf(context, element, m)), m++});

    pw.Widget listView = pw.ListView(children: list);

    return listView;
  }

  pw.Widget createPageRoomPdf(context, item, m) {
    List<pw.Widget> list = [];
    list.add(createTablePdf(m, context));
    list.add(createTablePdfPointers(m, context));
    pw.Widget listView = pw.ListView(children: list);
    return listView;
  }

  createTablePdf(index, context) {
    var i = 0;
    var t = "";
    List<List<String>> listString = [];
    listString.add(<String>['Nome', 'Coordenadas (cm)', 'Tamanho (cm)', "Cor"]);
    bloc.selectPlan.rooms[index].walls.forEach((element) => {
          i++,
          listString.add(<String>[
            element.name,
            '(${element.initialX},${element.initialY}) (${element.finalX}, ${element.finalY})',
            '${hipotenusa(element).toStringAsFixed(2)}',
            "${colorString(i - 1)}"
          ])
        });

    return pw.Table.fromTextArray(context: context, data: listString);
  }

  createTablePdfPointers(index, context) {
    var i = 0;
    var t = "";
    List<List<String>> listString = [];
    listString.add(<String>['Nome', 'Coordenadas (cm)', "Cor"]);
    bloc.selectPlan.rooms[index].vertices.forEach((element) => {
          i++,
          listString.add(<String>[
            element.name,
            '(${element.coordX},${element.coordY})',
            "${colorString(i - 1)}"
          ])
        });

    return pw.Table.fromTextArray(context: context, data: listString);
  }

  double hipotenusa(item) {
    return pow(
        pow(double.parse((item.finalX - item.initialX).toString()), 2) +
            pow(double.parse((item.finalY - item.initialY).toString()), 2),
        1 / 2);
  }

  var pngBytes;
  var scr = new GlobalKey();
  final pdf = pw.Document();

  void pdfCreate() async {
    final image = PdfImage.file(
      pdf.document,
      bytes: pngBytes,
    );

    pdf.addPage(pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: pw.Text('Portable Document Format',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.Header(
                  level: 0,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Text('Documento Ultra V', textScaleFactor: 2),
                        pw.PdfLogo()
                      ])),
              pw.Paragraph(
                  text:
                      'Esse documento contém todo o mapeamento feito pela equipe Ultra V do seu imóvel.'),

              pw.Header(level: 1, text: 'Cômodo: Sala de Estar'),
              pw.Paragraph(text: "Planta Baixa:"),
              pw.Image(image),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Paragraph(text: "Paredes e portas:"),

              createPagesRoomsPdf(context),
              createTablePdf(0, context),
              // pw.Table.fromTextArray(
              //     context: context,
              //     data: const <List<String>>[
              //       <String>['Nome', 'Coordenadas (cm)', 'Tamanho (cm)', "Cor"],
              //       <String>['Parede 1', '(0,200) (0, 0)', '500 cm', "Laranja"],
              //       <String>['Parede 2', '(0,200) (0, 0)', '500 cm', "Laranja"],
              //     ]),

              // pw.ListView(children: [
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Paragraph(text: "Vértices:"),
              //  ]),
              createTablePdfPointers(0, context),

              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Paragraph(
                  text:
                      'The Portable Document Format (PDF) is a file format developed by Adobe in the 1990s to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems. Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it. PDF was standardized as an open format, ISO 32000, in 2008, and no longer requires any royalties for its implementation.'),
              // pw.Paragraph(
              //     text:
              //         'Today, PDF files may contain a variety of content besides flat text and graphics including logical structuring elements, interactive elements such as annotations and form-fields, layers, rich media (including video content) and three dimensional objects using U3D or PRC, and various other data formats. The PDF specification also provides for encryption and digital signatures, file attachments and metadata to enable workflows requiring these features.'),
              // pw.Header(level: 1, text: 'History and standardization'),
              pw.Paragraph(
                  text:
                      "Adobe Systems made the PDF specification available free of charge in 1993. In the early years PDF was popular mainly in desktop publishing workflows, and competed with a variety of formats such as DjVu, Envoy, Common Ground Digital Paper, Farallon Replica and even Adobe's own PostScript format."),
              pw.Paragraph(
                  text:
                      'PDF was a proprietary format controlled by Adobe until it was released as an open standard on July 1, 2008, and published by the International Organization for Standardization as ISO 32000-1:2008, at which time control of the specification passed to an ISO Committee of volunteer industry experts. In 2008, Adobe published a Public Patent License to ISO 32000-1 granting royalty-free rights for all patents owned by Adobe that are necessary to make, use, sell, and distribute PDF compliant implementations.'),
              pw.Paragraph(
                  text:
                      "PDF 1.7, the sixth edition of the PDF specification that became ISO 32000-1, includes some proprietary technologies defined only by Adobe, such as Adobe XML Forms Architecture (XFA) and JavaScript extension for Acrobat, which are referenced by ISO 32000-1 as normative and indispensable for the full implementation of the ISO 32000-1 specification. These proprietary technologies are not standardized and their specification is published only on Adobe's website. Many of them are also not supported by popular third-party implementations of PDF."),
              pw.Paragraph(
                  text:
                      'On July 28, 2017, ISO 32000-2:2017 (PDF 2.0) was published. ISO 32000-2 does not include any proprietary technologies as normative references.'),
              pw.Header(level: 1, text: 'Technical foundations'),
              pw.Paragraph(text: 'The PDF combines three technologies:'),
              pw.Bullet(
                  text:
                      'A subset of the PostScript page description programming language, for generating the layout and graphics.'),
              pw.Bullet(
                  text:
                      'A font-embedding/replacement system to allow fonts to travel with the documents.'),
              pw.Bullet(
                  text:
                      'A structured storage system to bundle these elements and any associated content into a single file, with data compression where appropriate.'),
              pw.Header(level: 2, text: 'PostScript'),
              pw.Paragraph(
                  text:
                      'PostScript is a page description language run in an interpreter to generate an image, a process requiring many resources. It can handle graphics and standard features of programming languages such as if and loop commands. PDF is largely based on PostScript but simplified to remove flow control features like these, while graphics commands such as lineto remain.'),
              pw.Paragraph(
                  text:
                      'Often, the PostScript-like PDF code is generated from a source PostScript file. The graphics commands that are output by the PostScript code are collected and tokenized. Any files, graphics, or fonts to which the document refers also are collected. Then, everything is compressed to a single file. Therefore, the entire PostScript world (fonts, layout, measurements) remains intact.'),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Paragraph(
                        text:
                            'As a document format, PDF has several advantages over PostScript:'),
                    pw.Bullet(
                        text:
                            'PDF contains tokenized and interpreted results of the PostScript source code, for direct correspondence between changes to items in the PDF page description and changes to the resulting page appearance.'),
                    pw.Bullet(
                        text:
                            'PDF (from version 1.4) supports graphic transparency; PostScript does not.'),
                    pw.Bullet(
                        text:
                            'PostScript is an interpreted programming language with an implicit global state, so instructions accompanying the description of one page can affect the appearance of any following page. Therefore, all preceding pages in a PostScript document must be processed to determine the correct appearance of a given page, whereas each page in a PDF document is unaffected by the others. As a result, PDF viewers allow the user to quickly jump to the final pages of a long document, whereas a PostScript viewer needs to process all pages sequentially before being able to display the destination page (unless the optional PostScript Document Structuring Conventions have been carefully complied with).'),
                  ]),
              pw.Header(level: 1, text: 'Content'),
              pw.Paragraph(
                  text:
                      'A PDF file is often a combination of vector graphics, text, and bitmap graphics. The basic types of content in a PDF are:'),
              pw.Bullet(
                  text:
                      'Text stored as content streams (i.e., not encoded in plain text)'),
              pw.Bullet(
                  text:
                      'Vector graphics for illustrations and designs that consist of shapes and lines'),
              pw.Bullet(
                  text:
                      'Raster graphics for photographs and other types of image'),
              pw.Bullet(text: 'Multimedia objects in the document'),
              pw.Paragraph(
                  text:
                      'In later PDF revisions, a PDF document can also support links (inside document or web page), forms, JavaScript (initially available as plugin for Acrobat 3.0), or any other types of embedded contents that can be handled using plug-ins.'),
              pw.Paragraph(
                  text:
                      'PDF 1.6 supports interactive 3D documents embedded in the PDF - 3D drawings can be embedded using U3D or PRC and various other data formats.'),
              pw.Paragraph(
                  text:
                      'Two PDF files that look similar on a computer screen may be of very different sizes. For example, a high resolution raster image takes more space than a low resolution one. Typically higher resolution is needed for printing documents than for displaying them on screen. Other things that may increase the size of a file is embedding full fonts, especially for Asiatic scripts, and storing text as graphics. '),
              pw.Header(
                  level: 1, text: 'File formats and Adobe Acrobat versions'),
              pw.Paragraph(
                  text:
                      'The PDF file format has changed several times, and continues to evolve, along with the release of new versions of Adobe Acrobat. There have been nine versions of PDF and the corresponding version of the software:'),
              pw.Table.fromTextArray(
                  context: context,
                  data: const <List<String>>[
                    <String>['Date', 'PDF Version', 'Acrobat Version'],
                    <String>['1993', 'PDF 1.0', 'Acrobat 1'],
                    <String>['1994', 'PDF 1.1', 'Acrobat 2'],
                    <String>['1996', 'PDF 1.2', 'Acrobat 3'],
                    <String>['1999', 'PDF 1.3', 'Acrobat 4'],
                    <String>['2001', 'PDF 1.4', 'Acrobat 5'],
                    <String>['2003', 'PDF 1.5', 'Acrobat 6'],
                    <String>['2005', 'PDF 1.6', 'Acrobat 7'],
                    <String>['2006', 'PDF 1.7', 'Acrobat 8'],
                    <String>['2008', 'PDF 1.7', 'Acrobat 9'],
                    <String>['2009', 'PDF 1.7', 'Acrobat 9.1'],
                    <String>['2010', 'PDF 1.7', 'Acrobat X'],
                    <String>['2012', 'PDF 1.7', 'Acrobat XI'],
                    <String>['2017', 'PDF 2.0', 'Acrobat DC'],
                  ]),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
              pw.Paragraph(
                  text:
                      'Text is available under the Creative Commons Attribution Share Alike License.')
            ]));

    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Container(
    //           width: 900,
    //           color: PdfColors.black,
    //           child: pw.Column(children: [
    //             pw.Image(image),
    //             pw.Text("Sala",
    //                 style: pw.TextStyle(color: PdfColors.orange600)),
    //             pw.Container(
    //                 color: PdfColors.white,
    //                 width: 300,
    //                 child: pw.Column(children: [
    //                   pw.Container(
    //                       color: PdfColors.white,
    //                       width: 300,
    //                       margin: pw.EdgeInsets.all(10),
    //                       child: pw.Text("Parede 1")),
    //                   pw.Container(
    //                       color: PdfColors.white,
    //                       width: 300,
    //                       margin: pw.EdgeInsets.all(10),
    //                       child: pw.Text("Coordenadas:  (0,0) - (0, 500)")),
    //                   pw.Container(
    //                       color: PdfColors.white,
    //                       width: 300,
    //                       margin: pw.EdgeInsets.all(10),
    //                       child: pw.Text("Tamanho:  500 cm")),
    //                 ])),
    //             for (var i in [0, 1, 2, 3, 4, 5]) wallsPdf(),
    //             for (var i in [0, 1, 2, 3, 4, 5]) wallsPdf(),
    //             for (var i in [0, 1, 2, 3, 4, 5]) wallsPdf(),
    //           ])); // Center
    //     }));

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

  Widget imageRender(p, isVisible) {
    scr = new GlobalKey();
    return isVisible
        ? new RepaintBoundary(
            key: scr,
            child: Column(children: <Widget>[
              metricPlanRefactor(this.deleteLastLine, '$planCm cm'),
              Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: CustomPaint(
                        size: Size(planSize, planSize),
                        painter: p,
                      ))),
              metricPlan('0 cm', '$planCm  cm')
            ]))
        : Container();
  }

  var isLoad = true;
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
              //  pngBytes != null ? Image.memory(pngBytes) : Container(),
              InkWell(
                  onTap: () {
                    takescrshot();
                  },
                  child: Container(child: Text("Gerar PDF"))),

              imageRender(painter2, isVisible)
              // Container(
              //     padding: EdgeInsets.all(5),
              //     child: Container(
              //         padding: EdgeInsets.all(2),
              //         decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white)),
              //         child: CustomPaint(
              //           size: Size(planSize, planSize),
              //           painter: painter,
              //         ))),
              // //),
              // metricPlan('0 cm', '$planCm  cm'),

              //Print daqui:

              // buttonAdd('Adicionar Cômodo', Colors.deepOrangeAccent,
              //     Colors.white, this.addRoomsList),
            ])))),
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
                        style: TextStyle(color: Colors.black)))),
            Expanded(
                flex: 1,
                child: Container(
                    child: Text(right,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black)))),
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
                  style: TextStyle(color: Colors.black),
                ))),
          ],
        ));
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
    // print("Esse é o valor:");
    // print("finish");
    // print(room.lines);

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
          ..color = element.color ?? Colors.white
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
