import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ultravmobile/extra/Prefs.dart';
import 'package:ultravmobile/model/project.dart';
import '../extra/Constants.dart' as Constants;
import 'package:hasura_connect/hasura_connect.dart';
import '../extra/Messages.dart' as Messages;

String url = Constants.ENDPOINT_PRIVATE_MICRO;
HasuraConnect hasuraConnect = HasuraConnect(url, token: (isError) async {
  var token = await Prefs().getPrefString("token");
  return "Bearer $token";
});

String docGetProjects = """
query plumbingPlans {
  plumbingPlans{
    id
     name
    rooms {
      id
      name
      vertices {
        coordX
        coordY
        id
        name
      }
      walls {
        height
        finalX
        finalY
        id
        initialX
        initialY
        name
        tubes {
          finalX
          finalY
          id
          initialX
          initialY
          tubeType
        }
        wallType
      }
    }
    scale
  }
}
""";

String docGetProject = """
query findPlumbingPlan(\$id: ID!) {
  findPlumbingPlan(id:\$id){
    id
     name
    rooms {
      id
      name
      vertices {
        coordX
        coordY
        id
        name
      }
      walls {
        height
        finalX
        finalY
        id
        initialX
        initialY
        name
        tubes {
          finalX
          finalY
          id
          initialX
          initialY
          tubeType
        }
        wallType
      }
    }
    scale
  }
}
""";

String docDeleteProject = """
mutation deletePlumbingPlan(\$input: DeletePlumbingPlanInput!){
  deletePlumbingPlan(input: \$input){
    errors
  }
}
""";

String docDeleteRoom = """
mutation deleteRoom(\$input: DeleteRoomInput!){
  deleteRoom(input: \$input){
    errors
  }
}
""";

String docDeleteWall = """
mutation deleteWall(\$input: DeleteWallInput!){
  deleteWall(input: \$input){
    errors
  }
}
""";

String docDeleteTube = """
mutation deleteTube(\$input: DeleteTubeInput!){
  deleteTube(input: \$input){
    errors
  }
}
""";

String docDeleteVertex = """
mutation deleteVertex(\$input: DeleteVertexInput!){
   deleteVertex(input: \$input){
    errors
  }
}
""";

String docSetProject = """
mutation createPlumbingPlan(\$input: CreatePlumbingPlanInput!){
  createPlumbingPlan(input: \$input){
    errors
    plumbingPlan{
        id
     name
    rooms {
      id
      name
      vertices {
        coordX
        coordY
        id
        name
      }
      walls {
        height
        finalX
        finalY
        id
        initialX
        initialY
        name
        tubes {
          finalX
          finalY
          id
          initialX
          initialY
          tubeType
        }
        wallType
      }
    }
    scale
    }
  }
  
}
""";

String docSetRoom = """
mutation createRoom(\$input: CreateRoomInput!){
  createRoom(input: \$input){
    errors
}
}
""";

String docSetWall = """
mutation createWall(\$input: CreateWallInput!){
  createWall(input: \$input){
    errors
          wall {
        finalX
        finalY
        id
        initialX
        initialY
        name
        wallType
      }
  }
}
""";

String docSetTube = """
mutation createTube(\$input: CreateTubeInput!){
  createTube(input: \$input){
    errors
  }
}
""";

String docSetJun = """
mutation createTubeConnector(\$input: CreateTubeConnectorInput!){
  createTubeConnector(input: \$input){
    errors
  }
}
""";

String docSetVertice = """
mutation createVertex(\$input: CreateVertexInput!){
  createVertex(input: \$input){
    errors
  }
}

""";

class BlocPlan {
//MARK: - VAR AND LET
  var description = "";
  List<Project> project = [];
  List<Project> room = [];
  List<Wall> walls = [];
  List<Wall> wallsRooms = [];
  Project selectPlan;
  Room selectRoom;
  Wall selectWall;
  RoomProject roomProject;
  List<String> categoriasConnect = <String>['Joelho', 'U'];
  int filtroConnect = 0;
  String dropdowTubeConnect = 'Joelho';

  List<String> categoriasRooms = <String>[];
  int filtroRoom = 0;
  String dropdowTubeRoom = '';
  String dateTime = "";

//MARK: - CONTROLLER
  var controllerNameProject = new TextEditingController();
  var controllerScaleProject = new TextEditingController();
  var cotrollerType = new TextEditingController();

  var controllerNameRoom = new TextEditingController();
  var controllerIdProjectRoom = new TextEditingController();

//MARK: - STREAM
  var planListStreamController = BehaviorSubject<List<Project>>();
  var loadingAddProjectStreamController = BehaviorSubject<bool>();
  var dateStreamController = BehaviorSubject<String>();

  var roomListStreamController = BehaviorSubject<List<Room>>();
  var loadingAddRoomStreamController = BehaviorSubject<bool>();

  var wallsListStreamController = BehaviorSubject<List<Wall>>();
  var loadingAddWallStreamController = BehaviorSubject<bool>();

  var loadingAddTubeStreamController = BehaviorSubject<bool>();

//MARK: - BIND FUNCTIONS
  Function(String, String) alert;
  Function(String, String) alertPlan;
  Function(String, String) alertRoom;
  Function(String, String) alertRoom2;
  Function(String, String) alertTube;

  //MARK: - CONSTRUCTOR
  BlocPlan() {}

//MARK: - FUNCTIONS

  double calcPlanMinX() {
    var minValue = 500000000.0;
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialX.toString()) < minValue)
                {minValue = double.parse(element.initialX.toString())},
              if (double.parse(element.finalX.toString()) < minValue)
                {minValue = double.parse(element.finalX.toString())},
            });

    return minValue;
  }

  double calcPlanMaxX() {
    var minValue = 500000000.0;
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialX.toString()) > maxValue)
                {
                  maxValue = double.parse(element.initialX.toString()),
                },
              if (double.parse(element.finalX.toString()) > maxValue)
                {
                  maxValue = double.parse(element.finalX.toString()),
                },
            });

    return maxValue;
  }

  double calcPlanMinY() {
    var minValue = 500000000.0;
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialY.toString()) < minValue)
                {minValue = double.parse(element.initialY.toString())},
              if (double.parse(element.finalY.toString()) < minValue)
                {minValue = double.parse(element.finalY.toString())},
            });

    return minValue;
  }

  double calcPlanMaxY() {
    var minValue = 500000000.0;
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialY.toString()) > maxValue)
                {
                  maxValue = double.parse(element.initialY.toString()),
                },
              if (double.parse(element.finalY.toString()) > maxValue)
                {
                  maxValue = double.parse(element.finalY.toString()),
                },
            });

    return maxValue;
  }

  double calcPlanY() {
    var minValue = 500000000.0;
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialY.toString()) > maxValue)
                {
                  maxValue = double.parse(element.initialY.toString()),
                },
              if (double.parse(element.finalY.toString()) > maxValue)
                {
                  maxValue = double.parse(element.finalY.toString()),
                },
              if (double.parse(element.initialY.toString()) < minValue)
                {minValue = double.parse(element.initialY.toString())},
              if (double.parse(element.finalY.toString()) < minValue)
                {minValue = double.parse(element.finalY.toString())},
            });

    return maxValue - minValue;
  }

  double calcPlanX() {
    var minValue = 500000000.0;
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialX.toString()) > maxValue)
                {
                  maxValue = double.parse(element.initialX.toString()),
                },
              if (double.parse(element.finalX.toString()) > maxValue)
                {
                  maxValue = double.parse(element.finalX.toString()),
                },
              if (double.parse(element.initialX.toString()) < minValue)
                {minValue = double.parse(element.initialX.toString())},
              if (double.parse(element.finalX.toString()) < minValue)
                {minValue = double.parse(element.finalX.toString())},
            });

    return maxValue - minValue;
  }

  double calcPlanTotalMaxX() {
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialX.toString()) > maxValue)
                {
                  maxValue = double.parse(element.initialX.toString()),
                },
              if (double.parse(element.finalX.toString()) > maxValue)
                {
                  maxValue = double.parse(element.finalX.toString()),
                },
            });

    return maxValue;
  }

  double calcPlanTotalMaxY() {
    var maxValue = 0.0;

    selectRoom.walls
        .where((f) => f.wallType == 1)
        .toList()
        .forEach((element) => {
              if (double.parse(element.initialY.toString()) > maxValue)
                {
                  maxValue = double.parse(element.initialY.toString()),
                },
              if (double.parse(element.finalY.toString()) > maxValue)
                {
                  maxValue = double.parse(element.finalY.toString()),
                },
            });

    return maxValue;
  }

  void initialPlan() {
    var projectItem = Project();
    projectItem.id = "1";
    projectItem.name = "Casa do João";

    var projectItem2 = Project();
    projectItem2.id = "2";
    projectItem2.name = "Apto do José";

    project.add(projectItem);
    project.add(projectItem2);
    planListStreamController.add(project);
  }

  void initRooms() {
    if (selectPlan != null) {
      roomListStreamController.add(selectPlan.rooms);
    }
  }

  void initWalls() {
    if (selectRoom != null) {
      print("EEEEEEEEEEE");
      print(selectRoom);
      wallsListStreamController.add(selectRoom.walls ?? []);
    }
  }

  void setAllWallsRoom(
      RoomProject room, RoomProject doors, List<Point> pointers) {
    var i = 0;
    var j = 0;
    var h = 0;
    loadingAddWallStreamController.add(false);

    var p = 0;

    List<Point> q = [];
    List<Point> tx = [];
    List<Point> ty = [];
    pointers.forEach((element) => {
          tx = q.where((i) => i.x == element.x).toList(),
          ty = tx.where((i) => i.y == element.y).toList(),
          if (ty.length == 0) {q.add(element)}
        });

    selectRoom.walls.forEach((element) => {deleteWall(element.id)});

    selectRoom.vertices.forEach((element) => {deleteVertex(element.id)});

    room.lines.forEach((element) => {
          setWall(
              element.pointStart.x,
              element.pointStart.y,
              element.pointFinish.x,
              element.pointFinish.y,
              1,
              "Parede ${i + 1}",
              element.height),
          i = i + 1,
          //     print(i)
          if (room.lines.length == i)
            {alertRoom2("Sucesso", "Cômodo adicionado com sucesso")}
        });

    doors.lines.forEach((element) => {
          setWall(
              element.pointStart.x,
              element.pointStart.y,
              element.pointFinish.x,
              element.pointFinish.y,
              2,
              "Porta ${h + 1}",
              element.height),
          h++
        });

    if (room.lines.length == 0) {
      alertRoom("Erro", "Adicione alguma parede para continuar");
    }
    List<VerticeName> verticeName = [];
    List<VerticeName> exclude = [];
    var m = 0;
    var n = 0;
    room.lines.forEach((element) => {
          n = 0,
          room.lines.forEach((element2) => {
                if (m > n)
                  {
                    print("divisor"),
                    print(element.pointFinish.x),
                    print(element.pointFinish.y),
                    print(element2.pointStart.x),
                    print(element2.pointStart.y),
                    print("divisor"),
                    if (element.pointStart.x == element2.pointStart.x &&
                        element.pointStart.y == element2.pointStart.y)
                      {
                        verticeName.add(VerticeName(
                            element.pointStart.x,
                            element.pointStart.y,
                            "Vértice ${n + 1}, ${m + 1}")),
                        // exclude.add(VerticeName(element.pointStart.x,
                        //     element.pointStart.y, "Vértice $n, $m"))
                      },
                    if (element.pointStart.x == element2.pointFinish.x &&
                        element.pointStart.y == element2.pointFinish.y)
                      {
                        verticeName.add(VerticeName(
                            element.pointStart.x,
                            element.pointStart.y,
                            "Vértice ${n + 1}, ${m + 1}")),
                        // exclude.add(VerticeName(element.pointStart.x,
                        //     element.pointStart.y, "Vértice $n, $m"))
                      },
                    if (element.pointFinish.x == element2.pointStart.x &&
                        element.pointFinish.y == element2.pointStart.y)
                      {
                        verticeName.add(VerticeName(
                            element.pointFinish.x,
                            element.pointFinish.y,
                            "Vértice ${n + 1}, ${m + 1}")),
                        // exclude.add(VerticeName(element.pointFinish.x,
                        //     element.pointFinish.y, "Vértice $n, $m"))
                      },
                    if (element.pointFinish.x == element2.pointFinish.x &&
                        element.pointFinish.y == element2.pointFinish.y)
                      {
                        verticeName.add(VerticeName(
                            element.pointFinish.x,
                            element.pointFinish.y,
                            "Vértice ${n + 1}, ${m + 1}")),
                        // exclude.add(VerticeName(element.pointFinish.x,
                        //     element.pointFinish.y, "Vértice $n, $m"))
                      }
                  },
                n++
              }),
          m++
        });

    // q.forEach((element) => {
    //       if (j == q.length - 1)
    //         {
    //           //      {setVertice(element.x, element.y, selectRoom.id, "Vértice $j , 0")}
    //         }
    //       else
    //         {
    //           //      setVertice(
    //           //     element.x, element.y, selectRoom.id, "Vértice $j , ${j + 1}")
    //         },
    //       setVertice(element.x, element.y, selectRoom.id, "Vértice $j"),
    //       j = j + 1,
    //     });

    verticeName.forEach((element) => {
          setVertice(element.x, element.y, selectRoom.id, element.name),
        });
  }

  void setAllWallsRooms() {
    var i = 0;
    loadingAddWallStreamController.add(false);
    selectPlan.rooms.forEach((element) => {
          element.walls.forEach((element2) => {
                // setWall(element2.initialX, element2.initialY, element2.finalX,
                //     element2.finalY, 1, "Parede $i"),
                // i = i + 1,
                // print(i)
              })
        });
    // doors.lines.forEach((element) => {
    //       setWall(element.pointStart.x, element.pointStart.y,
    //           element.pointFinish.x, element.pointFinish.y, 2, "Porta"),
    //       i = i + 1,
    //     });
  }

  void setAllTubesWall(RoomProject tubes, List<Point> jun) {
    var i = 0;
    if (tubes.lines.length == 0) {
      return;
    }
    loadingAddTubeStreamController.add(true);

    selectWall.tubes.forEach((element) => {deleteTube(element.id)});

    tubes.lines.forEach((element) => {
          setTube(
              element.pointStart.x,
              element.pointStart.y,
              element.pointFinish.x,
              element.pointFinish.y,
              element.color == Colors.red ? 1 : 2,
              ""),
          i++,
          if (tubes.lines.length == i)
            {alertTube("Sucesso", "Tubulação cadastrada com sucesso")},
        });

    jun.forEach((element) => {
          //setJun
          setTube(element.x, element.y, element.x, element.y, filtroConnect + 5,
              ""),
        });
  }

//MARK: - SERVICE
  Future<void> getAllPlans() async {
    project = [];
    planListStreamController.add(null);
    var response = await hasuraConnect.query(
      docGetProjects,
      //variables: {"lat": latitudeCoord, "lng": longitudeCoord}
    );
    planListStreamController.add([]);
    //   print(response);

    print(response);

    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      print("alertErrorGraph");
    }
    var result = response["data"]["plumbingPlans"];
    if (result != null) {
      result.forEach((element) => {project.add(Project().populate(element))});
      planListStreamController.add(project);

      initRooms();

      initWalls();
    }
  }

  Future<void> getPlan() async {
//    planListStreamController.add(null);
    var response = await hasuraConnect
        .query(docGetProject, variables: {"id": selectPlan.id});
    //   planListStreamController.add([]);
    //  print(response);
    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      //    print("alertErrorGraph");
    }
    var result = response["data"]["findPlumbingPlan"];
    selectPlan = Project().populate(result);
    roomListStreamController.add(selectPlan.rooms);
    initRooms();
    print("DDDDDDDDDDDDDDDDDDDD");
    selectPlan.rooms.forEach((element) => {
          print("foreach"),
          print(element),
          if (element.id == selectRoom.id) {selectRoom = element, initWalls()}
        });
  }

  Future<void> setProject() async {
    loadingAddProjectStreamController.add(true);
    var response = await hasuraConnect.mutation(docSetProject, variables: {
      "input": {
        "name": controllerNameProject.text,
        "scale": double.parse(controllerScaleProject.text),
      }
    });
    loadingAddProjectStreamController.add(false);
    var errors = response["data"]["createPlumbingPlan"]["errors"];

    if (errors != null) {
      getAllPlans();
      //  alertLogin(Messages.ATTENTION, errors.last);
      return;
    }

    controllerNameProject.text = '';
    controllerScaleProject.text = '';

    var result = response["data"]["createPlumbingPlan"]["plumbingPlan"];
    if (result != null) {
      print("AAAAAAAABBBBBBBBBBBCCCCCCCC");
      // project = [];
      // result.forEach((element) => {project.add(Project().populate(element))});
      // planListStreamController.add(project);
      getAllPlans();
    }
  }

  Future<void> setRoom() async {
    loadingAddRoomStreamController.add(true);
    var response = await hasuraConnect.mutation(docSetRoom, variables: {
      "input": {
        "name": controllerNameRoom.text,
        "plumbingPlanId": selectPlan.id
      }
    });
    loadingAddRoomStreamController.add(false);
    var errors = response["data"]["createRoom"]["errors"];

    if (errors != null) {
      // print(errors);
      alertRoom(Messages.ATTENTION, errors.last);
      return;
    }
    alertRoom("Sucesso", "Cômodo cadastrado com sucesso");
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    getPlan();
    //chamar a id pumb
  }

  Future<void> deletePlan(id) async {
    planListStreamController.add(null);
    var response = await hasuraConnect.mutation(docDeleteProject, variables: {
      "input": {"plumbingPlanId": id}
    });
    loadingAddRoomStreamController.add(false);
    var errors = response["data"]["deletePlumbingPlan"]["errors"];

    if (errors != null) {
      // print(errors);
      alertRoom(Messages.ATTENTION, errors.last);
      return;
    }
    alertRoom("Sucesso", "Projeto removido com sucesso");
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    planListStreamController.add(project);
    getAllPlans();
  }

  Future<void> deleteRoom(id) async {
    roomListStreamController.add(null);
    var response = await hasuraConnect.mutation(docDeleteRoom, variables: {
      "input": {"roomId": id}
    });
    loadingAddRoomStreamController.add(false);
    var errors = response["data"]["deleteRoom"]["errors"];

    if (errors != null) {
      // print(errors);
      alertRoom(Messages.ATTENTION, errors.last);
      return;
    }
    alertRoom("Sucesso", "Cômodo removido com sucesso");
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    var i = 0;
//     selectPlan.rooms.forEach((element) => {
//           if (element.id == id) {selectPlan.rooms.removeAt(i)},
//           i++
//         });

// print(selectPlan.rooms);
    roomListStreamController.add(selectPlan.rooms);
    getPlan();

    // getAllPlans();
    //chamar a id pumb
  }

  Future<void> deleteWall(id) async {
    roomListStreamController.add(null);
    var response = await hasuraConnect.mutation(docDeleteWall, variables: {
      "input": {"wallId": id}
    });
    loadingAddRoomStreamController.add(false);
    var errors = response["data"]["deleteWall"]["errors"];

    if (errors != null) {
      return;
    }
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    roomListStreamController.add(selectPlan.rooms);
    getPlan();
  }

  Future<void> deleteTube(id) async {
    roomListStreamController.add(null);
    var response = await hasuraConnect.mutation(docDeleteTube, variables: {
      "input": {"tubeId": id}
    });
    loadingAddRoomStreamController.add(false);
    var errors = response["data"]["deleteTube"]["errors"];

    if (errors != null) {
      return;
    }
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    roomListStreamController.add(selectPlan.rooms);
    getPlan();
  }

  Future<void> deleteVertex(id) async {
    roomListStreamController.add(null);
    var response = await hasuraConnect.mutation(docDeleteVertex, variables: {
      "input": {"vertexId": id}
    });
    loadingAddRoomStreamController.add(false);
    var errors = response["data"]["deleteVertex"]["errors"];

    if (errors != null) {
      return;
    }
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    roomListStreamController.add(selectPlan.rooms);
    getPlan();
  }

  Future<void> setWall(
      initialX, initialY, finalX, finalY, wallType, name, height) async {
    loadingAddWallStreamController.add(true);
    var response = await hasuraConnect.mutation(docSetWall, variables: {
      "input": {
        "name": name,
        "roomId": selectRoom.id,
        'initialX': initialX.round(),
        'initialY': initialY.round(),
        'finalX': finalX.round(),
        'finalY': finalY.round(),
        'wallType': wallType,
        'height': height
      }
    });

    loadingAddWallStreamController.add(false);
    var errors = response["data"]["createWall"]["errors"];

    if (errors != null) {
      // print(errors);
      // getPlan();
      //  alertLogin(Messages.ATTENTION, errors.last);
      return;
    }
    print(response["data"]["createWall"]["wall"]);
//print(Wall().populate(response["data"]["createWalls"]["wall"]).name);
    controllerNameRoom.text = '';
    controllerIdProjectRoom.text = '';
    selectRoom.walls
        .add(Wall().populate(response["data"]["createWall"]["wall"]));
    initWalls();
    //  getPlan();
    //chamar a id pumb
  }

  Future<void> setTube(
      initialX, initialY, finalX, finalY, tubeType, name) async {
    var response = await hasuraConnect.mutation(docSetTube, variables: {
      "input": {
        "wallId": selectWall.id,
        'initialX': initialX.round(),
        'initialY': initialY.round(),
        'finalX': finalX.round(),
        'finalY': finalY.round(),
        'tubeType': tubeType,
      }
    });

    loadingAddTubeStreamController.add(false);
    var errors = response["data"]["createTube"]["errors"];

    if (errors != null) {
      //   print(errors);
      getPlan();
      //  alertLogin(Messages.ATTENTION, errors.last);
      return;
    }
  }

  Future<void> setJun(coordX, coordY, wallType, name) async {
    var response = await hasuraConnect.mutation(docSetJun, variables: {
      "input": {
        "tubeId": "1",
        'coordX': coordX.round(),
        'coordY': coordY.round(),
        'tubeConnectionType': wallType,
      }
    });

    loadingAddWallStreamController.add(false);
    var errors = response["data"]["createTubeConnector"]["errors"];

    if (errors != null) {
      //  print(errors);
      getPlan();
      //  alertLogin(Messages.ATTENTION, errors.last);
      return;
    }
  }

  Future<void> setVertice(coordX, coordY, roomId, name) async {
    var response = await hasuraConnect.mutation(docSetVertice, variables: {
      "input": {
        "roomId": roomId,
        'coordX': coordX.round(),
        'coordY': coordY.round(),
        'name': name,
      }
    });

    loadingAddWallStreamController.add(false);
    var errors = response["data"]["createTubeConnector"]["errors"];

    if (errors != null) {
      //  print(errors);
      getPlan();
      //  alertLogin(Messages.ATTENTION, errors.last);
      return;
    }
  }

//MARK: - FINISH
  @override
  void dispose() {
    // listStreamController.close();
  }
}
