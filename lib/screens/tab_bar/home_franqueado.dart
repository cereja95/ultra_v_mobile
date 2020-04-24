import 'package:flutter/material.dart';
import 'package:ultravmobile/screens/project/plan_list_screen.dart';
import 'package:ultravmobile/screens/schedule/schedule_list.dart';
import 'package:ultravmobile/screens/schedule/schedule_list_micro.dart';
import 'package:ultravmobile/screens/search/call_client.dart';
import 'package:ultravmobile/screens/search/search_professional.dart';
import 'package:ultravmobile/screens/settings/settings.dart';
import 'package:ultravmobile/screens/settings/settings_micro.dart';
import 'package:ultravmobile/screens/user/login_screen.dart';
import '../../utils/color.dart';

class HomeFranqueadoPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeFranqueado();
  }
}

class _HomeFranqueado extends State<HomeFranqueadoPage> {
  int genero;
  int filtro;
  String latCep;
  String lonCep;
  String email = "";
  String senha = "";
  double count = 0;
  IconData icon = Icons.map;
  TabController _tabController;
  void closure = () => () {
        print("oi");
      };
  int index = 0;
  void s = (int numOne, int numTwo) => () {
        print(numOne * numTwo);
      };

  @override
  void initState() {
    super.initState();
  }

  // Future<Function> updateFilterParams(genero, filtro, latCep, lonCep) async {
  //   setState(() {
  //     this.genero = genero;
  //     this.filtro = filtro;
  //     this.latCep = latCep;
  //     this.lonCep = lonCep;
  //   });
  //   print(genero);
  //   print(filtro);
  //   print(latCep);
  //   print(lonCep);
  // }

  // Future<Function> updateClosure(closure) async {
  //   setState(() {
  //     this.closure = closure;
  //   });
  //   print("aqui");
  // }

  // void func() {
  //   Navigator.push(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.fade,
  //           child: OfferFilterFul(this.genero, this.filtro,
  //               this.latCep, this.lonCep, closure)));
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            bottomNavigationBar: TabBar(
              isScrollable: false,
              onTap: (indexTab) {
                setState(() {
                  index = indexTab;
                });
              },
              labelPadding: EdgeInsets.all(15.0),
              tabs: [
                Tab(
                  icon: Icon(Icons.featured_play_list),
                ),
                Tab(
                  icon: Icon(Icons.notifications),
                ),
                Tab(
                  icon: Icon(Icons.tune),
                ),
                Tab(
                  icon: Icon(Icons.settings),
                ),
              ],
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(25.0),
              indicatorColor: Colors.transparent,
            ),
            body: TabBarView(
              children: <Widget>[
                CallClient(),
                ScheduleListPageMicro(),
                MyAppPlanList(),
                ConfigurationMicro(),
              ],
            )));
  }

  Widget navBar() {
    switch (index) {
      case 500:
        return AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          leading: IconButton(
            icon: Icon(
              icon,
              color: Colors.red,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                setState(() {
                  icon = Icons.list;
                  // func();
                });
              },
            ),
          ],
        );

      default:
        return AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Massagem App"),
            leading: IconButton(
              icon: Icon(
                icon,
                size: 0,
              ),
            ));
    }
  }
}
