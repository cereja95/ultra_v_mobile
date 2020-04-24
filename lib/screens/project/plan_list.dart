import "package:flutter/material.dart";
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';
import 'package:ultravmobile/screens/user/signup_screen.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';

class PlanListCell extends StatelessWidget {
  final List<Project> products;
  Function onTap;

  PlanListCell(this.products, this.onTap);
  var bloc = BlocProvider.getBloc<BlocPlan>();

  //Products([this.products = const []] ); usado quando esse valor nao pode ser mudado
  Widget _cellProduct(BuildContext context, int index) {
    // var t = products[index].favorito;
    print(products[index].name);

    void _showDialog(title, describe, id, {bool more: false}) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(describe),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Confirmar",
                    style: TextStyle(color: Colors.blue, fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).pop();
                  bloc.deletePlan(id);
                },
              ),
              new FlatButton(
                child: new Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
              Row(children: <Widget>[
                Expanded(
                    child: Container(
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
                )),
                InkWell(
                    onTap: () {
                      _showDialog(
                          "Atenção",
                          "Deseja realmente remover essa planta?",
                          products[index].id);
                      //  bloc.deletePlan(products[index].id);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: EdgeInsets.only(top: 0, bottom: 0, right: 5),
                      child: Icon(
                        Icons.delete,
                        color: Colors.purple,
                        size: 28,
                      ),
                    )),
              ])
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
      child: Text(
        "Você ainda não possui nenhum projeto",
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
