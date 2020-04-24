import "package:flutter/material.dart";
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/screens/user/signup_screen.dart';

class SearchCell extends StatelessWidget {
  final List<Franqueados> products;
  Function onTap;

  SearchCell(this.products, this.onTap);

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
                          backgroundImage: NetworkImage(products[index].foto))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 15),
                          child: Text(products[index].nome,
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
                            products[index].endereco,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14.0, fontFamily: 'Lao Sangam MN'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Text(
                            products[index].telefone,
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
      child: Text("Nenhum microfranqueado se encontra na sua região",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.purple, fontSize: 16)),
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
