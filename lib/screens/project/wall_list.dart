import "package:flutter/material.dart";
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/user/signup_screen.dart';

class WallListCell extends StatelessWidget {
  final List<Wall> products;
  Function onTap;

  WallListCell(this.products, this.onTap);

  //Products([this.products = const []] ); usado quando esse valor nao pode ser mudado
  Widget _cellProduct(BuildContext context, int index) {
    // var t = products[index].favorito;
    print(products[index].name);
    return new InkWell(
        onTap: () {
          this.onTap(products[index]);
        },
        child: Card(
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
            ],
          ),
        ));
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
