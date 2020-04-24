import "package:flutter/material.dart";
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/user/signup_screen.dart';
import 'dart:math';

class PropsListWallCell extends StatelessWidget {
  final List<Wall> products;
  Function onTap;
  String selectWall;
  PropsListWallCell(this.products, this.onTap, this.selectWall);

  //Products([this.products = const []] ); usado quando esse valor nao pode ser mudado
  Widget _cellProduct(BuildContext context, int index) {
    print(products[index].id);

    return new InkWell(
        onTap: () {
          print("ssss");
          print(selectWall);
          onTap(products[index].id);
        },
        child: Card(
          color: selectWall == products[index].id ? Colors.red : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                child: Text(products[index].name,
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
                  // margin:
                  //     EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      // Container(
                      //     margin: EdgeInsets.only(),
                      //     child: Text("Seção:",
                      //         textAlign: TextAlign.start,
                      //         style: TextStyle(
                      //             fontSize: 15.0,
                      //             fontWeight: FontWeight.bold,
                      //             fontFamily: "Lao Sangam MN"),
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1)),
                      // Container(
                      //     margin: EdgeInsets.only(left: 15),
                      //     child: Text("20 cm",
                      //         textAlign: TextAlign.start,
                      //         style: TextStyle(
                      //             fontSize: 15.0,
                      //             color: HexColor('#333333'),
                      //             fontWeight: FontWeight.bold,
                      //             fontFamily: "Lao Sangam MN"),
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1)),
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
                                  products[index].initialX.toString() +
                                  ", " +
                                  products[index].initialY.toString() +
                                  ") - (" +
                                  products[index].finalX.toString() +
                                  ", " +
                                  products[index].finalY.toString() +
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
                              hipotenusa(products[index]).toStringAsFixed(2) +
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
            ],
          ),
        ));
  }

  String status(int value) {
    int status = value ?? 5;
    switch (status) {
      case 5:
        return "Joelho";
        break;
      case 6:
        return "U";
        break;
    }
  }

  double hipotenusa(Wall item) {
    return pow(
        pow(double.parse((item.finalX - item.initialX).toString()), 2) +
            pow(double.parse((item.finalY - item.initialY).toString()), 2),
        1 / 2);
  }

  Widget formaLista() {
    Widget lista = Center(
        child: Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        "Você ainda não possui nenhum parede nesse cômodo",
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    ));

    if (products.length > 0) {
      lista = ListView.builder(
        primary: false,
        shrinkWrap: true,
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
