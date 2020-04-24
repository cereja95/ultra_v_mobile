import 'package:flutter/material.dart';
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/cliente.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/call/call_screen.dart';
import 'package:ultravmobile/screens/settings/settings.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import "../../model/franqueados.dart";
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';
import '../../utils/Monetary.dart' as Monetary;
import 'package:date_time_format/date_time_format.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ScheduleDetail extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScheduleDetailPage();
  }
}

class ScheduleDetailPage extends StatefulWidget {
  ScheduleDetailPage();

  @override
  _ScheduleDetailPage createState() => _ScheduleDetailPage();
}

class _ScheduleDetailPage extends State<ScheduleDetailPage> {
  Schedule schedule;
  var bloc = BlocProvider.getBloc<BlocSearchProfessional>();
  @override
  void initState() {
    super.initState();
    initBind();
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

  void initBind() {
    bloc.alertDetail = _showDialog;
    // bloc.selectCallStream.add(null);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(back: true),
        body: Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: HexColor("#DDDDDD"),
          child: Column(children: <Widget>[
            placeGeneral("Detalhe do Chamado"),
            StreamBuilder<CallModel>(
                stream: bloc.selectCallStream.stream,
                initialData: bloc.selectCall,
                builder: (context, snapshot) {
                  var franqueado = snapshot.data;
                  if (snapshot.data == null) {
                    return Center(child: progress(0, 10));
                  }

                  return Expanded(
                      child: GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: SingleChildScrollView(
                              child: Container(
                                  // margin: EdgeInsets.all(25),

                                  child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          margin: EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 0,
                                              bottom: 15),
                                          child: Column(children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    width: 100,
                                                    height: 100,
                                                    margin: EdgeInsets.only(
                                                        left: 4,
                                                        right: 0,
                                                        top: 8,
                                                        bottom: 8),
                                                    child: CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage:
                                                            NetworkImage(franqueado
                                                                    .franqueado
                                                                    .foto
                                                                    .isEmpty
                                                                ? "https://chatuba.com.br/wp-content/uploads/2018/11/2018-11-28-tipos-de-tubulacoes-para-instalacao-hidraulica-800x418.jpg"
                                                                : franqueado
                                                                    .franqueado
                                                                    .foto))),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        margin: EdgeInsets.only(
                                                            left: 16,
                                                            right: 16,
                                                            top: 15),
                                                        child: Text(
                                                            franqueado
                                                                    .franqueado
                                                                    .nome
                                                                    .isEmpty
                                                                ? "MicroFranqueado 1"
                                                                : franqueado
                                                                    .franqueado
                                                                    .nome,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Lao Sangam MN"),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets.only(
                                                            left: 16,
                                                            right: 16,
                                                            top: 8),
                                                        child: Text(
                                                          franqueado
                                                                  .franqueado
                                                                  .endereco
                                                                  .isEmpty
                                                              ? "Rua das Flores, 232 - Caraguatatuba"
                                                              : franqueado
                                                                  .franqueado
                                                                  .endereco,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontFamily:
                                                                  'Lao Sangam MN'),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets.only(
                                                            left: 16,
                                                            right: 16,
                                                            top: 8),
                                                        child: Text(
                                                          franqueado
                                                                  .franqueado
                                                                  .telefone
                                                                  .isEmpty
                                                              ? "(41)99908-0987"
                                                              : franqueado
                                                                  .franqueado
                                                                  .telefone,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontFamily:
                                                                  'Lao Sangam MN'),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ])))),
                              inf(
                                  "Orçamento:",
                                  Monetary.formatterMoney(double.parse(
                                      franqueado.price.toString())),
                                  franqueado),
                              infSchedule(franqueado),
                              statusRequest(franqueado),
                              //statusCard('O Franqueado deseja marcar uma visita têcnica no dia 22/02/2020 as 12:00 h, o que deseja fazer?', true),
                              //statusCard(
                              // 'Agendamento confirmado para o dia 22/02/2020 as 12:00 h',
                              //   false),
                              // statusCard(
                              //     'O franqueado avisou que concluiu o servi��o solicitado, confirma o procedimento?',
                              //     true),

                              // statusCard('Serviço concluído', false),
                              Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 0,
                                          bottom: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 15, left: 15, right: 25),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Problema reportado:",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, left: 15, right: 25),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              franqueado.description,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              child:
                                                  // Image.network(
                                                  //     franqueado.photo)),
                                                  franqueado.photo == ""
                                                      ? Container()
                                                      : imageLoad(
                                                          franqueado.photo))
                                        ],
                                      ))),

                              franqueado.status == 10
                                  ? Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          top: 0,
                                          bottom: 15),
                                      child: Column(children: <Widget>[
                                        infDesc(
                                            "Laudo",
                                            bloc.selectCall.complaint ??
                                                "Não informado"),
                                        SizedBox(height: 10)
                                      ]))
                                  : Container(),

                              franqueado.status <= 5
                                  ? button("Cancelar Chamado", Colors.red, () {
                                      print("CANCELAR");
                                      cancelDialog(context);
                                    })
                                  : Container(),

                              franqueado.status > 8
                                  ? buttonRating()
                                  : Container(),

                              //     button("Conversar com Franqueado", Colors.orange, () {}),
                              // button("Ver laudo do procedimento", Colors.orange, () {}),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          )))));
                })
          ]),
        ));
  }

  Widget imageLoad(url) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/loadi.gif',
      image: url,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 3 / 4,
      fit: BoxFit.fitHeight,
    );
  }

  void cancelDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
              width: 300,
              height: 225,
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
                          "Cancelar Serviço",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ))),
                    Container(
                        margin: EdgeInsets.only(top: 8, left: 10, right: 10),
                        child: Text(
                          "Deseja realmente cancelar o serviço? Essa ação não poderá ser revertida",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        )),
                    txtModalGeneral(
                        "Razão de cancelamento", bloc.controllerCancelReason),
                    streamButtonModal(() {
                      Navigator.of(context).pop();
                      bloc.updateRequestCancelCLient();
                      //bloc.setRoom();
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buttonRating() {
    print("Status:");
    print(bloc.selectCall.status);
    return Container(
        margin: EdgeInsets.only(top: 0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15, left: 15, right: 25),
                alignment: Alignment.topLeft,
                child: Text(
                  "Avaliação:",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 15, right: 25),
                alignment: Alignment.topLeft,
                child: Text(
                  bloc.selectCall.status == 10
                      ? "Você avaliou seu serviço com"
                      : "Escolha uma nota para o serviço prestado",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              bloc.selectCall.status == 10
                  ? RatingBarIndicator(
                      rating: double.parse(
                          bloc.selectCall.bathroomAmount.toString()),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 45.0,
                    )
                  : RatingBar(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        bloc.ratingValue = rating;
                      },
                    ),
              bloc.selectCall.status != 10
                  ? button("Avaliar Chamado", Colors.purple, () {
                      bloc.updateRating();
                    })
                  : Container(),
              SizedBox(
                height: 20,
              )
            ])));
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
    return InkWell(
        onTap: () {
          function();
        },
        child: Container(
            child: Container(
                padding: EdgeInsets.all(15),
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    // color: background,
                    //  borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                child: Text(
                  title,
                  style: TextStyle(color: background, fontSize: 18),
                  textAlign: TextAlign.center,
                ))));
  }

  Widget streamButtonModal(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingCancelRequestStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return progressModal(10, 10);
          }
          return Row(
            children: <Widget>[
              buttonAdd('Confirmar', Colors.red, Colors.white, function),
              buttonAdd('Cancelar', Colors.grey, Colors.white, () {
                Navigator.of(context).pop();
              })
            ],
          );
        });
  }

  Widget turnOption() {
    return Card(
        margin: EdgeInsets.only(bottom: 10, left: 30, right: 30),
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
                  width: MediaQuery.of(context).size.width - 140,
                  child: Text(value)),
            );
          }).toList(),
        ));
  }

  Widget infSchedule(CallModel item) {
    String date = item.scheduledTime != null
        ? DateTimeFormat.format(DateTime.parse(item.scheduledTime),
                format: 'd/m/Y')
            .toString()
        : "";
    return item.scheduledTime == null
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: 0),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
                child: Column(children: <Widget>[
                  infDesc("Data do agendamento",
                      "${item.roomAmount == 0 ? "Manhã do dia " : "Tarde do dia "} ${date}"),
                  SizedBox(height: 10)
                ])));
  }

  Widget statusRequest(CallModel item) {
    var status = item.status ?? 9;
    var turn = item.roomAmount == 0 ? "Manhã" : "Tarde";
    String value = Monetary.formatterMoney(double.parse(item.price.toString()));
    print("Dormir");
    print(item.scheduledTime);
    String date = item.scheduledTime != null
        ? DateTimeFormat.format(DateTime.parse(item.scheduledTime),
                format: 'd/m/Y')
            .toString()
        : "";
    switch (status) {
      case 1:
        return statusCard(
          'Aguardando o microfranqueado aceitar o horário de agendamento na parte da $turn às $date',
          false,
        );
        // return statusCard(
        //     'Seu chamado foi enviado, aguardando a resposta do micro franqueado',
        //     false);
        break;
      case 2:
        return statusCard(
          'Aguardando o microfranqueado aceitar o horário de agendamento na parte da $turn às $date',
          false,
        );

        return statusCard(
          'Deseja aceitar o horário de agendamento $date?',
          true,
          actionPositive: () {
            bloc.updateRequestAccept(false, null);
          },
          actionNegative: () {
            bloc.updateRequestAccept(true, bloc.controllerScheduleCancel.text);
          },
          widget: Container(
            height: 100,
            margin: EdgeInsets.only(top: 0, left: 35, right: 35, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: TextField(
              controller: bloc.controllerScheduleCancel,
              maxLines: 30,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 17),
                hintText: 'Motivo da recusa, se houver',
                focusedBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ),
        );
        break;
      case 3:
        return statusCard('Escolha um novo horário de agendamento', true,
            actionPositive: () {
          bloc.updateRequestChangeTime();
        }, actionNegative: () {
          cancelDialog(context);
        },
            widget: item.schedulingCancelReason == null
                ? Container()
                : Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 25, right: 25),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Motivo do micro-franqueado:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        item.schedulingCancelReason,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            bottom: 10, left: 25, right: 35, top: 0),
                        child: Text(
                          "Data do serviço:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        )),
                    FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            bloc.dateTime = "$date";
                            bloc.dateStreamController.add(DateTimeFormat.format(
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
                                  width: MediaQuery.of(context).size.width - 70,
                                  padding: EdgeInsets.only(
                                      top: 17, bottom: 17, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                      color: Colors.grey[50],
                                      //                   <--- border width here
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
                            bottom: 10, left: 25, right: 35, top: 5),
                        child: Text(
                          "Horário do serviço:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        )),
                    turnOption()
                  ]));
        return statusCard(
            'Aguardando novo horário de agendamento de visita', false);
        break;
      case 4:
        return statusCard(
            'Serviço aceito para a parte da $turn às $date', false);
        break;
      case 5:
        return statusCard(
            'O microfranqueado atualizou o valor do serviço para $value, o que deseja fazer?',
            true, actionPositive: () {
          bloc.updateRequestStatus(4);
        }, actionNegative: () {
          cancelDialog(context);
        });
        break;
      case 6:
        return statusCard('Cancelado o serviço pelo micro franqueado', false,
            widget: item.cancelReason == null
                ? Container()
                : Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 25, right: 25),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Motivo:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        item.cancelReason,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]));
      case 7:
        return statusCard('Cancelado o serviço pelo cliente', false,
            widget: item.cancelReason == null
                ? Container()
                : Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 25, right: 25),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Motivo:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 20),
                      alignment: Alignment.topLeft,
                      child: Text(
                        item.cancelReason,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]));
      case 8:
        return statusCard(
            'O micro franqueado sinalizou a conclusão do serviço, confirma a finalização?',
            true, actionPositive: () {
          bloc.updateRequestStatus(9);
        }, actionNegative: () {});
      case 9:
        return statusCard('O serviço foi concluído', false);
      case 10:
        return statusCard('O serviço foi concluído', false);
    }
  }
}

datetimeConvert() {
  DateTime myDatetime = DateTime.parse("2018-07-10 12:04:35");
  print(myDatetime.toIso8601String());
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

Widget inf(title, description, CallModel item) {
  String date = item.createdAt != null
      ? DateTimeFormat.format(DateTime.parse(item.createdAt),
              format: 'H:i - d/m/Y')
          .toString()
      : "";
  return Container(
      margin: EdgeInsets.only(top: 0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
          child: Column(children: <Widget>[
            infDesc("Data de Solicitação", date),
            infDesc(title, description, size: 22),
            SizedBox(height: 10)
          ])));
}

Widget infDesc(title, description, {double size = 14}) {
  return Column(children: <Widget>[
    Container(
      margin: EdgeInsets.only(top: 15, left: 25, right: 25),
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        textAlign: TextAlign.left,
      ),
    ),
    Container(
        margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 0),
        alignment: Alignment.topLeft,
        child: Text(
          description,
          style: TextStyle(
              color: Colors.black, fontSize: size, fontWeight: FontWeight.w400),
          textAlign: TextAlign.left,
        )),
  ]);
}

Widget statusCard(description, haveChoice,
    {Function actionPositive, Function actionNegative, Widget widget}) {
  return Container(
      margin: EdgeInsets.only(top: 0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, left: 25, right: 25),
              alignment: Alignment.topLeft,
              child: Text(
                "Status:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 20),
              alignment: Alignment.topLeft,
              child: Text(
                description,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            ),
            widget ?? Container(),
            haveChoice
                ? buttonsChoice(actionPositive, actionNegative)
                : SizedBox()
          ])));
}

Widget button(title, color, function) {
  return InkWell(
    onTap: () {
      function();
    },
    child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(top: 20, left: 35, right: 35),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ))),
  );
}

Widget buttonsChoice(positiveAction, negativeAction) {
  return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  positiveAction();
                },
                child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Aceitar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  negativeAction();
                },
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Recusar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
        ],
      ));
}
