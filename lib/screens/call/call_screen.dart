import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/screens/schedule/schedule_detail.dart';
import 'package:ultravmobile/screens/settings/settings.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import 'dart:io';
import 'dart:async';
import "../../model/franqueados.dart";
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CallScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CallPage();
  }
}

class CallPage extends StatefulWidget {
  CallPage();

  @override
  _CallPage createState() => _CallPage();
}

class _CallPage extends State<CallPage> {
  Franqueados franqueado;
  var bloc = BlocProvider.getBloc<BlocSearchProfessional>();

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  var update = Colors.white;

  @override
  void initState() {
    super.initState();
    initBinds();
    bloc.imageStreamController.add(false);
    bloc.loadingCallStreamController.add(false);
    bloc.imageSend = null;
    bloc.controllerDescription.text = "";
    bloc.controllerBathCount.text = "";
    bloc.controllerRoomCount.text = "";
    bloc.controllerBedCount.text = "";
    bloc.controllerKitchenCount.text = "";
    bloc.optionTurn = "Manhã";
    bloc.dateTime = "";
    bloc.dateStreamController.add(null);

    franqueado = bloc.selectFranqueado;
  }

  void _showDialog(title, describe, function) {
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
                function();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogg(title, describe, function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(describe),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirmar"),
              onPressed: () {
                Navigator.of(context).pop();
                function();
              },
            ),
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Function onTapped(CallModel item) {
    bloc.selectCall = item;
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => ScheduleDetail()))
        .then((s) {
      Navigator.of(context).pop();
    });
    //ScheduleDetail
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(focusNode: _nodeText1

            // , toolbarButtons: [
            //   //button 1
            //   (node) {
            //     return GestureDetector(
            //       onTap: () => {
            //         node.unfocus(),
            //       },
            //       child: Container(
            //         color: Colors.white,
            //         padding: EdgeInsets.all(8.0),
            //         child: Text(
            //           "CLOSE",
            //           style: TextStyle(color: Colors.black),
            //         ),
            //       ),
            //     );
            //   },
            // ]
            ),
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

  //MARK: -  FUNCTIONS
  void initBinds() {
    bloc.alertCall = this._showDialog;
    bloc.alertCallOptions = this._showDialogg;
    bloc.goDetailsCall = this.onTapped;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      // what you get if you cancel
    } else {
      bloc.imageSend = image;
      bloc.imageStreamController.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: navBarGeneral(back: true),
        body: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: update,
            color: HexColor("#DDDDDD"),
            child: Column(children: [
              placeGeneral("Solicitar Chamado"),
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
                                  child: Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 12, left: 35, right: 35, top: 20),
                                  child: Text(
                                    "Tipo de Serviço:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              city(),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 35, right: 35, top: 10),
                                  child: Text(
                                    "Número de Quartos:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  focusNode: _nodeText1,
                                  keyboardType: TextInputType.number,
                                  controller: bloc.controllerBedCount,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Ex: 2',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 35, right: 35, top: 10),
                                  child: Text(
                                    "Número de Banheiros:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  focusNode: _nodeText2,
                                  keyboardType: TextInputType.number,
                                  controller: bloc.controllerBathCount,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Ex: 1',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 35, right: 35, top: 10),
                                  child: Text(
                                    "Número de Salas:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  focusNode: _nodeText3,
                                  keyboardType: TextInputType.number,
                                  controller: bloc.controllerRoomCount,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Ex: 1',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 35, right: 35, top: 10),
                                  child: Text(
                                    "Número de Cozinhas:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: TextField(
                                  focusNode: _nodeText4,
                                  keyboardType: TextInputType.number,
                                  controller: bloc.controllerKitchenCount,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Ex: 1',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 0, left: 35, right: 35, top: 10),
                                  child: Text(
                                    "Descrição do Problema:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              Container(
                                height: 200,
                                margin: EdgeInsets.only(
                                    top: 15, left: 35, right: 35),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: TextField(
                                  focusNode: _nodeText5,
                                  controller: bloc.controllerDescription,
                                  maxLines: 30,
                                  textCapitalization: TextCapitalization.none,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Descreva o problema',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 10, left: 35, right: 35, top: 30),
                                  child: Text(
                                    "Data do serviço:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              FlatButton(
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      bloc.dateTime = "$date";
                                      bloc.dateStreamController.add(
                                          DateTimeFormat.format(
                                              DateTime.parse(date.toString()),
                                              format: 'd/m/Y'));
                                      print('confirm $date');
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.pt);
                                  },
                                  child: StreamBuilder<String>(
                                      stream: bloc.dateStreamController.stream,
                                      initialData: "Selecione um horário",
                                      builder: (context, snapshot) {
                                        return Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                70,
                                            padding: EdgeInsets.only(
                                                top: 17,
                                                bottom: 17,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              border: Border.all(
                                                color: Colors.grey[50],
                                                width:
                                                    1, //                   <--- border width here
                                              ),
                                            ),
                                            child: Text(
                                              snapshot.data ?? "Selecione",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.purple,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ));
                                      })),

                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      bottom: 10, left: 35, right: 35, top: 20),
                                  child: Text(
                                    "Horário do serviço:",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                              turn(),
                              // Container(
                              //     margin: EdgeInsets.only(
                              //         top: 10, left: 10, right: 10),
                              //     child: RadioButtonGroup(
                              //         orientation:
                              //             GroupedButtonsOrientation.HORIZONTAL,
                              //         activeColor: Colors.purple,
                              //         labels: <String>[
                              //           "Manhã",
                              //           "Tarde",
                              //         ],
                              //         labelStyle: TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold),
                              //         onSelected: (String selected) =>
                              //             bloc.optionTurn = selected)),
                              imageStream(),

                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: StreamBuilder<String>(
                                    stream: bloc.priceStreamController.stream,
                                    initialData:
                                        "Previsão do serviço: R\$ 0,00",
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ??
                                            "Previsão do serviço: R\$ 0,00",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      );
                                    }),
                              ),

                              streamButton(() {}),
                            ],
                          ))))))
            ])));
  }

  Widget imageStream() {
    return StreamBuilder<bool>(
        stream: bloc.imageStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          //para tratar quando nõ vem resposta, sempre que comeca vem null
          // if (snapshot.hasError) {}
          // if (!snapshot.hasData) {}
          if (snapshot.data ?? false) {
            return Column(children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Container(
                      margin: EdgeInsets.only(left: 60, right: 60),
                      child: Image.file(bloc.imageSend))),
              InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      width: 200,
                      height: 40,
                      child: Text(
                        "Alterar imagem",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.purple, fontSize: 16),
                      ))),
            ]);
          }
          return InkWell(
            onTap: () {
              getImage();
            },
            child: Container(
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 25, left: 35, right: 10),
                      child: Icon(
                        Icons.photo,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                    Expanded(
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(
                                    top: 25, left: 0, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text(
                                  "Adicionar Foto",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ))))
                  ],
                )),
          );
        });
  }

  Widget city() {
    return Card(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        color: HexColor("#FFFFFF"),
        child: DropdownButton<String>(
          value: bloc.dropdowType,
          onChanged: (String newValue) {
            setState(() {
              bloc.dropdowType = newValue;
              bloc.filtro = bloc.categorias.indexOf(newValue);
            });
          },
          items: bloc.categorias.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 90,
                  child: Text(value)),
            );
          }).toList(),
        ));
  }

  Widget turn() {
    return Card(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        color: HexColor("#FFFFFF"),
        child: DropdownButton<String>(
          value: bloc.optionTurn,
          onChanged: (String newValue) {
            setState(() {
              bloc.optionTurn = newValue;
            });
          },
          items:
              bloc.categoriasTurn.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 90,
                  child: Text(value)),
            );
          }).toList(),
        ));
  }

  Widget streamButton(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingCallStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          //para tratar quando nõ vem resposta, sempre que comeca vem null
          // if (snapshot.hasError) {}
          // if (!snapshot.hasData) {}
          if (snapshot.data ?? false) {
            return progress(55, 10);
          }
          return InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                bloc.imageSend == null
                    ? bloc.createCall()
                    : bloc.createCallApi();
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(
                        top: 30, left: 35, right: 35, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      "Enviar Chamado",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    )),
              ));
        });
  }

  Widget progress(double topConst, double bottomConst) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: topConst,
          bottom: bottomConst,
        ),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
  }
}
