import 'package:flutter/material.dart';
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/cliente.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/screens/schedule/schedule_detail_micro.dart';
import 'package:ultravmobile/screens/search/call_cell.dart';
import 'package:ultravmobile/screens/search/search_cell.dart';
import 'package:ultravmobile/screens/search/search_details.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import 'client_detail.dart';
import '../../extra/Constants.dart' as Constants;
import 'package:ultravmobile/screens/search/bloc_professional.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class CallClient extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CallClientPage();
  }
}

class CallClientPage extends StatefulWidget {
  @override
  _CallClientPage createState() => _CallClientPage();
}

class _CallClientPage extends State<CallClientPage> {
  List<Cliente> _products = [];
  var bloc = BlocProvider.getBloc<BlocProfessional>();
  Function onTapped(CallModel item) {
    bloc.selectCall = item;
    bloc.selectCallStream.add(item);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ScheduleDetailMicro()));
    //ScheduleDetail
  }

  @override
  void initState() {
    super.initState();
    bloc.calls = [];
    bloc.getCalls();
    infinity();
  }

  void infinity() {
    Future.delayed(const Duration(milliseconds: 10000), () {
      BlocProvider.getBloc<BlocProfessional>().getCallsInfinity();
      infinity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(),
        body: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_black.png"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              placeGeneral("Chamados"),
              Expanded(child: listStream())
            ])));
  }

  Widget listStream() {
    return new StreamBuilder<List<CallModel>>(
        stream: bloc.listCallStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CallCell([], onTapped);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }
          print(snapshot.data);
          return CallCell(snapshot.data, onTapped);
        });
  }

  Widget progress(double topConst, double bottomConst) {
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(
            top: topConst, bottom: bottomConst, left: 10, right: 10),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                HexColor(Constants.COLOR_SYSTEM))));
  }
}
