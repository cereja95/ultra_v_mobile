import 'package:flutter/material.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/model/schedule_model.dart';
import 'package:ultravmobile/screens/schedule/schedule_cell.dart';
import 'package:ultravmobile/screens/schedule/schedule_detail.dart';
import 'package:ultravmobile/screens/schedule/schedule_micro_cell.dart';
import 'package:ultravmobile/screens/search/bloc_professional.dart';
import 'package:ultravmobile/screens/search/search_cell.dart';
import 'package:ultravmobile/screens/search/search_details.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import 'package:ultravmobile/model/call_model.dart';
import '../../extra/Constants.dart' as Constants;
import 'package:bloc_pattern/bloc_pattern.dart';

class ScheduleListMicro extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScheduleListPageMicro();
  }
}

class ScheduleListPageMicro extends StatefulWidget {
  ScheduleListPageMicro({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScheduleListPageMicro createState() => _ScheduleListPageMicro();
}

class _ScheduleListPageMicro extends State<ScheduleListPageMicro> {
  List<Schedule> _products = [];

  var bloc = BlocProvider.getBloc<BlocProfessional>();
  Function onTapped() {
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (BuildContext context) => ScheduleDetail()));
  }

  @override
  void initState() {
    super.initState();
    bloc.schedules = [];
    bloc.getCallsSchedule();
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
                    fit: BoxFit.cover)
                // color: HexColor("#333333")
                ),
            child: Container(
                child: Column(children: <Widget>[
              placeGeneral("Agendamentos"),
              Expanded(child: listStream())
            ]))));
  }

  Widget listStream() {
    return new StreamBuilder<List<CallModel>>(
        stream: bloc.listScheduleStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ScheduleCellMicro([], onTapped);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }
          print(snapshot.data);
          return ScheduleCellMicro(snapshot.data, onTapped);
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
