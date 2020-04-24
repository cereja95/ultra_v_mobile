import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:ultravmobile/screens/search/bloc_search_professional.dart';
import 'package:ultravmobile/screens/search/search_cell.dart';
import 'package:ultravmobile/screens/search/search_details.dart';
import 'package:ultravmobile/utils/general_widgets.dart';
import '../user/signup_screen.dart';
import '../tab_bar/home.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import '../../extra/Constants.dart' as Constants;

class SearchProfessional extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SearchProfessionalPage();
  }
}

class SearchProfessionalPage extends StatefulWidget {
  SearchProfessionalPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchProfessionalPage createState() => _SearchProfessionalPage();
}

class _SearchProfessionalPage extends State<SearchProfessionalPage> {
  var bloc = BlocProvider.getBloc<BlocSearchProfessional>();
  bool isMap = false;
  get heightScreen => MediaQuery.of(context).size.height;
  String latitudeCoord = "-25.129039";
  String longitudeCoord = "-49.050651";
  String latitudeInit = "-25.129039";
  String longitudeInit = "-49.050651";
  List<String> lats = ["-25.129039", "-22.9035"];
  List<String> logns = ["-49.050651", "-43.2096"];
  //49
  List<String> categorias = <String>['Curitiba', 'Rio de Janeiro'];
  int filtro = 0;

  String dropdownValue = 'Curitiba';
//  List<Massager> _products = [];
  Position currentLocation;
  //LatLng _mainLocation = LatLng(-20.3388654, -40.2839906);
  LatLng _mainLocation = LatLng(-25.55, -49.22);
  List<Marker> markers = [];
  GoogleMapController myMapController;

  Function onTapped(Franqueados item) {
    bloc.selectFranqueado = item;
    _showDialog(goDetails, () {
      Navigator.pop(context);
    }, item);
  }

  Function goDetails(Franqueados item) {
    bloc.selectFranqueado = item;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SearchDetails()));
  }

  void _add(Franqueados item, lat, long) {
    var id = item.id;
    var markerIdVal = "$id";
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(lat), double.parse(long)),
      // infoWindow: InfoWindow(
      //   title: name,
      //   snippet: skills,
      // ),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        if (isMap) {
          onTapped(item);
        }
      },
    );

    setState(() {
      // adding a new marker to map
      markers.add(marker);
    });
  }

  @override
  void initState() {
    bloc.products = [];
    bloc.getService(latitudeCoord, longitudeCoord);
    bloc.addMark = _add;
    super.initState();
  }

  void getPermissionStatus() async {}

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    try {
      currentLocation = await locateUser();
    } catch (e) {}
    if (currentLocation == null) {
      //   getData(latitudeCoord, longitudeCoord, genero, filtro, page, id);
    } else {
      setState(() {
        this._mainLocation =
            LatLng(currentLocation.latitude, currentLocation.longitude);
      });

      print('center $_mainLocation');
      if (currentLocation.latitude == null) {
        bloc.getService(latitudeCoord, longitudeCoord);
      } else {
        print(_mainLocation.longitude.toString());
        setState(() {
          //   latitudeCoord = _mainLocation.latitude.toString();
          //   longitudeCoord = _mainLocation.longitude.toString();
          //   latitudeInit = _mainLocation.latitude.toString();
          //   longitudeInit = _mainLocation.longitude.toString();
        });
        print(latitudeCoord);
        bloc.getService(latitudeCoord, longitudeCoord);
        //  getData(latitudeCoord, longitudeCoord, genero, filtro, page, id);
      }
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: navBarGeneral(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: HexColor("#DDDDDD"),
            child: Column(
              children: <Widget>[
                placeGeneral("Assistência Têcnica"),
                city(),
                Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(children: <Widget>[
                          Container(child: typeList(isMap)),
                          //    buttonMap(),
                        ])))
                //   map()),
              ],
            )));
  }

  Widget city() {
    return Card(
        margin: EdgeInsets.only(bottom: 20),
        color: HexColor("#FFFFFF"),
        child: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              filtro = categorias.indexOf(newValue);
              bloc.getService(lats[filtro], logns[filtro]);
            });
          },
          items: categorias.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(value)),
            );
          }).toList(),
        ));
  }

  Widget navBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
          height: 40, child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
      backgroundColor: HexColor("#333333"),
    );
  }
  // Widget navBar(title) {
  //   return AppBar(
  //     automaticallyImplyLeading: false,
  //     title: Text(
  //       title,
  //       style: TextStyle(
  //           color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  //     ),
  //     backgroundColor: HexColor("#333333"),
  //   );
  // }

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

  Widget title(value) {
    return Container(
      margin: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        value,
        style: TextStyle(color: Colors.white, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buttonMap() {
    return Container(
        margin: EdgeInsets.only(right: 16, bottom: 16),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: HexColor("#FFFFFF"),
          onPressed: () {
            setState(() {
              isMap = !isMap;
            });
          },
          child: Icon(
            Icons.map,
            color: Colors.blue,
          ),
        ));
  }

  Widget typeList(isMap) => !isMap ? listStream() : map();

  Widget map() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 0),
        child: GoogleMap(
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          initialCameraPosition: CameraPosition(
            target: _mainLocation,
            zoom: 14.0,
          ),
          markers: Set<Marker>.from(markers),
          mapType: MapType.normal,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          onMapCreated: _onMapCreated,
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      myMapController = controller;
    });
  }

  Widget listStream() {
    return new StreamBuilder<List<Franqueados>>(
        stream: bloc.listStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SearchCell([], goDetails);
          }
          if (!snapshot.hasData) {
            return progress(10, 10);
          }
          print(snapshot.data);
          return SearchCell(snapshot.data, (goDetails));
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

  void _showDialog(onTap, close, item) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                content: Container(
                  width: 300,
                  height: 250,
                  child: cellMap(onTap, close, item),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget cellMap(onTap, close, item) {
    return InkWell(
        onTap: () {
          onTap(item);
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // InkWell(
                  //     onTap: () {
                  //       close();
                  //     },
                  //     child: Icon(
                  //       Icons.close,
                  //       color: Colors.blue,
                  //     )),
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 4, right: 0, top: 8, bottom: 8),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(item.foto)))),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 15),
                    child: Text(item.nome,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lao Sangam MN"),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Text(
                      item.endereco,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0, fontFamily: 'Lao Sangam MN'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Text(
                      item.telefone,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0, fontFamily: 'Lao Sangam MN'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
