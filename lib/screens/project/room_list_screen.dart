import 'package:flutter/material.dart';
import 'package:ultravmobile/model/project.dart';
import 'package:ultravmobile/screens/project/planDown.dart';
import 'package:ultravmobile/screens/project/room_list.dart';
import 'package:ultravmobile/screens/project/wall_list_screen.dart';
import 'package:ultravmobile/utils/color.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../../bloc/bloc_plan.dart';
import '../../extra/Constants.dart' as Constants;

class RoomListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoomListPage();
  }
}

class RoomListPage extends StatefulWidget {
  RoomListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoomListPage createState() => _RoomListPage();
}

class _RoomListPage extends State<RoomListPage> {
  var bloc = BlocProvider.getBloc<BlocPlan>();

  Function onTapped(Room item) {
    bloc.selectRoom = item;
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => WallsListPage()))
        .then((o) {
      bloc.getPlan();
    });
    ;
  }

  @override
  void initState() {
    super.initState();
    bloc.initRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(back: true),
        body: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_black.png"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              placeGeneral("Cômodos"),
              Expanded(child: listStream()),
              Row(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: createCicleFilter(
                          () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyAppDown()))
                              },
                          52.0,
                          Icons.remove_red_eye,
                          Colors.white)),
                  Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: createCicleFilter(() => roomAddDialog(context),
                          52.0, Icons.add, Colors.white)),
                ],
              )
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: new FloatingActionButton(
              //       backgroundColor: Colors.purple,
              //       onPressed: () {
              //         roomAddDialog(context);
              //       },
              //       child: new Icon(
              //         Icons.add,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ])));
  }

  Widget createCicleFilter(onTap, size, iconData, color) {
    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  Widget listStream() {
    return new StreamBuilder<List<Room>>(
        stream: bloc.roomListStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return RoomListCell([], onTapped);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }
          print(snapshot.data);
          return RoomListCell(snapshot.data, onTapped);
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)));
  }

  Widget txtGenericModal(name, controller) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 15, left: 1, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: Colors.grey)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 18),
          labelStyle: TextStyle(fontSize: 18),
          hintText: name,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    ));
  }

  void roomAddDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
              width: 300,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Center(
                            child: Text(
                          "Novo Cômodo",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ))),
                    txtGenericModal("Nome", bloc.controllerNameRoom),
                    streamButtonModal(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pop();
                      bloc.setRoom();
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget progressModal(double topConst, double bottomConst) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: topConst,
          bottom: bottomConst,
        ),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)));
  }

  Widget buttonAdd(title, background, color, function) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: InkWell(
            onTap: () {
              function();
            },
            child: Container(
                child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(color: color, fontSize: 18),
                      textAlign: TextAlign.center,
                    )))));
  }

  Widget streamButtonModal(function) {
    return StreamBuilder<bool>(
        stream: bloc.loadingAddRoomStreamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return progressModal(10, 10);
          }
          return buttonAdd(
              'Adicionar Cômodo', Colors.purple, Colors.white, function);
        });
  }
}
