import "package:flutter/material.dart";
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/user/signup_screen.dart';
import 'package:date_time_format/date_time_format.dart';

class ScheduleCell extends StatelessWidget {
  final List<CallModel> products;
  Function onTap;

  ScheduleCell(this.products, this.onTap);

  //Products([this.products = const []] ); usado quando esse valor nao pode ser mudado
  Widget _cellProduct(BuildContext context, int index) {
    // var t = products[index].favorito;
    print(products[0].franqueado.foto);
    return new InkWell(
        onTap: () {
          this.onTap();
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
            child: Column(children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 80,
                      height: 80,
                      margin:
                          EdgeInsets.only(left: 4, right: 0, top: 8, bottom: 8),
                      child: Image.network(
                          'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/calendar-512.png')),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 15),
                          child: Text(products[index].franqueado.nome,
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
                          child: Text(
                            products[index].scheduledTime != null
                                ? "${products[index].roomAmount == 0 ? "Manhã do dia " : "Tarde do dia "}${DateTimeFormat.format(DateTime.parse(products[index].scheduledTime), format: 'd/m/Y').toString()}"
                                : "",
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
            ])));
  }

  Widget favorito(favorito) {
    switch (favorito) {
      case 1:
        return Icon(
          Icons.favorite,
          color: HexColor("#C00613"),
          size: 28,
        );
      case 2:
        return Icon(
          Icons.favorite,
          color: Colors.grey,
          size: 28,
        );

      case 3:
        return Container(
            child: Center(
                child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            HexColor("#C00613"))))));
    }
  }

  Widget formaLista() {
    Widget lista = Center(
      child: Text(
        "Você ainda não possui nenhuma visita agendada",
        style: TextStyle(color: Colors.purple),
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
