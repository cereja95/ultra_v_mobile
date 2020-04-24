import "package:flutter/material.dart";
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/cliente.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/screens/user/signup_screen.dart';
import '../../extra/Constants.dart' as Constants;
import 'package:ultravmobile/screens/search/bloc_professional.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CallCell extends StatelessWidget {
  final List<CallModel> products;
  Function onTap;

  CallCell(this.products, this.onTap);

  Widget badge(title) {
    return Container(
      width: 100,
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.purple,
        // borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget infDesc(title, description) {
    return Row(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 15, left: 25, right: 25),
        alignment: Alignment.topLeft,
        child: Text(
          "${title}: $description",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          textAlign: TextAlign.left,
        ),
      )
    ]);
  }

  //Products([this.products = const []] ); usado quando esse valor nao pode ser mudado
  Widget _cellProduct(BuildContext context, int index) {
    // var t = products[index].favorito;
    return new InkWell(
        onTap: () {
          this.onTap(products[index]);
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
            child: Column(children: <Widget>[
              infDesc("Identificador", products[index].id),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      margin:
                          EdgeInsets.only(left: 4, right: 0, top: 8, bottom: 8),
                      child: CircleAvatar(
                          radius: 20,
                          backgroundImage: new AssetImage("assets/user.png"))),
                  //NetworkImage(products[index].foto))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 15),
                          child: Text(products[index].client.name ?? "Usuário",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lao Sangam MN"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Text(products[index].description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: 'Lao Sangam MN'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Text(
                            products[index].client.phoneNumber,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14.0, fontFamily: 'Lao Sangam MN'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              Row(children: [
                Expanded(child: badge(status(products[index].status)))
              ]),
              infDesc(
                  "Solicitado",
                  products[index].createdAt != null
                      ? DateTimeFormat.format(
                              DateTime.parse(products[index].createdAt),
                              format: 'h:i d/m/Y')
                          .toString()
                      : ""),
              SizedBox(height: 12)
            ])));
  }

  String status(int value) {
    int status = value ?? 1;
    switch (status) {
      case 1:
        return "Criado";
        break;
      case 2:
        return "Confirmação de agendamento";
        break;
      case 3:
        return "Confirmação de agendamento";
        break;
      case 4:
        return "Serviço Aceito";
        break;
      case 5:
        return "Aceitar Valor";
        break;
      case 6:
        return "Cancelado";
        break;
      case 7:
        return "Cancelado";
        break;
      case 8:
        return "Confirmar serviço";
      case 9:
        return "Concluído";
        break;
      case 10:
        return "Concluído";
        break;
      default:
        return "Criado";
        break;
    }
  }

  Widget formaLista() {
    Widget lista = Center(
      child: Text(
        "Você ainda não possui nenhum chamado",
        style: TextStyle(color: Colors.white),
      ),
    );

    if (products.length > 0) {
      lista = ListView.builder(
        itemBuilder: _cellProduct,
        itemCount: products.length,
      );
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return formaLista();
  }
}
