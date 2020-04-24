import 'package:flutter/material.dart';
import 'package:ultravmobile/screens/call/call_list_screen.dart';
import 'package:ultravmobile/screens/project/listProject.dart';
import 'package:ultravmobile/screens/schedule/schedule_list.dart';
import 'package:ultravmobile/screens/search/search_professional.dart';
import 'package:ultravmobile/screens/settings/settings.dart';
import 'package:ultravmobile/screens/user/login_screen.dart';
import '../../utils/color.dart';

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  int genero;
  int filtro;
  String latCep;
  String lonCep;
  String email = "";
  String senha = "";
  double count = 0;
  IconData icon = Icons.map;
  TabController _tabController;
  void closure = () => () {};
  int index = 0;
  void s = (int numOne, int numTwo) => () {
        print(numOne * numTwo);
      };

  @override
  void initState() {
    super.initState();
  }

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
                  icon: Icon(Icons.place),
                ),
                Tab(
                  icon: Icon(Icons.notifications),
                ),
                Tab(
                  icon: Icon(Icons.chat),
                ),
                // Tab(
                //   icon: Icon(Icons.panorama_vertical),
                // ),
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
                SearchProfessional(),
                ScheduleList(),
                CallList(),
                // ProjectPage(),
                Configuration(),
              ],
            )));
  }
}
