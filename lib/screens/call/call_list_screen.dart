import 'package:flutter/material.dart';
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/call/call_list.dart';
import 'package:ultravmobile/screens/schedule/schedule_cell.dart';
import 'package:ultravmobile/screens/schedule/schedule_detail.dart';
import 'package:ultravmobile/screens/search/call_cell.dart';
import 'package:ultravmobile/screens/search/search_cell.dart';
import 'package:ultravmobile/screens/search/search_details.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../../extra/Constants.dart' as Constants;
import '../tab_bar/home.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class CallList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CallListPage();
  }
}

class CallListPage extends StatefulWidget {
  CallListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CallListPage createState() => _CallListPage();
}

class _CallListPage extends State<CallListPage> {
  List<Schedule> _products = [];
  var bloc = BlocProvider.getBloc<BlocSearchProfessional>();

  Function onTapped(CallModel item) {
    bloc.selectCall = item;
    bloc.selectCallStream.add(item);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => ScheduleDetail()));
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
      BlocProvider.getBloc<BlocSearchProfessional>().getCallsInfinity();
      infinity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(),
        body: Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: HexColor("#DDDDDD"),
            child: Column(children: <Widget>[
              placeGeneral("Chamados"),
              Expanded(child: listStream())
            ])));
  }

  Widget navBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
          height: 40, child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
      backgroundColor: HexColor("#333333"),
    );
  }

  Widget place(title) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 0, bottom: 15),
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.purple,
        // borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget listStream() {
    return new StreamBuilder<List<CallModel>>(
        stream: bloc.listCallStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CallListCell([], onTapped);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }
          print(snapshot.data);
          return CallListCell(snapshot.data, onTapped);
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
