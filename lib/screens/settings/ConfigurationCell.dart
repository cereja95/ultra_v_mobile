import "package:flutter/material.dart";
import 'package:ultravmobile/extra/Prefs.dart';
import 'package:ultravmobile/model/settings.dart';
import 'package:ultravmobile/utils/color.dart';
import '../../extra/Constants.dart' as Constants;

class ConfigurationCell extends StatelessWidget {
  final List<Settings> products;
  final List<Icon> icons = [];
  final BuildContext context;
  Function updateScreen;

  ConfigurationCell(this.products, this.context);

  //Products([this.products = const []] ); usado quando esse valor nao pode ser mudado
  Widget _cellProduct(BuildContext context, int index) {
    return Card(
        margin: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 1),
        child: new InkWell(
            onTap: () {
              onTapped(products[index]);
            },
            child: Column(children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          left: 16, right: 0, top: 15, bottom: 15),
                      child: icons[index]),
                  Expanded(
                      child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 17),
                    child: Text(products[index].name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: "Lao Sangam MN"),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  )),
                  Container(
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 20, bottom: 20),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.purple,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ])));
  }

  void onTapped(configuration) {
    switch (configuration.icon) {
      case "perfil":
        break;
      case "faq":
        break;
      case "exit":
        Prefs().setPrefString("token", "");
        Navigator.of(context).pop();

        break;
      case "new_account_user":
        break;

      case "new_account_massage":
        break;
    }
  }

  Widget formaLista() {
    Widget lista = Center(
      child:
          Text("Sem itens no momento", style: TextStyle(color: Colors.purple)),
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
    for (final item in products) {
      switch (item.icon) {
        case "perfil":
          icons.add(
            Icon(
              Icons.person,
              color: HexColor(Constants.COLOR_SYSTEM),
              size: 28,
            ),
          );
          break;

        case "attach_money":
          icons.add(
            Icon(
              Icons.attach_money,
              color: HexColor(Constants.COLOR_SYSTEM),
              size: 28,
            ),
          );
          break;

        case "exit":
          icons.add(
            Icon(
              Icons.exit_to_app,
              color: Colors.purple,
              size: 28,
            ),
          );
          break;

        case "new_account_user":
          icons.add(
            Icon(
              Icons.person_add,
              color: HexColor(Constants.COLOR_SYSTEM),
              size: 28,
            ),
          );
          break;

        case "new_account_massage":
          icons.add(
            Icon(
              Icons.airline_seat_flat,
              color: HexColor(Constants.COLOR_SYSTEM),
              size: 28,
            ),
          );
          break;

        case "faq":
          icons.add(
            Icon(
              Icons.help,
              color: HexColor(Constants.COLOR_SYSTEM),
              size: 28,
            ),
          );
          break;

        default:
      }
    }
    return formaLista();
  }
}
