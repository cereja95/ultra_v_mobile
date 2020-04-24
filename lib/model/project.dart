import 'package:flutter/material.dart';

class Project {
  String id = '';
  String name = '';
  double scale = 0.0;
  List<Room> rooms = [];

  Project populate(Map<String, dynamic> dataResponse) {
    var project = Project();
    project.name = dataResponse["name"];
    project.id = dataResponse["id"];
    project.scale = dataResponse["scale"];

    var result = dataResponse["rooms"];
    if (result != null) {
      result.forEach((element) => {rooms.add(Room().populate(element))});
      project.rooms = rooms;
    }
    return project;
  }
}

class VerticeName {
  String name;
  double x;
  double y;
  VerticeName(x, y, name) {
    this.x = x;
    this.y = y;
    this.name = name;
  }
}

class Room {
  String id;
  String name;
  List<Vertice> vertices = [];
  List<Wall> walls = [];

  Room populate(Map<String, dynamic> dataResponse) {
    var room = Room();
    room.name = dataResponse["name"];
    room.id = dataResponse["id"];

    var result = dataResponse["walls"];
    if (result != null) {
      result.forEach((element) => {walls.add(Wall().populate(element))});
      room.walls = walls;
    }

    var resultV = dataResponse["vertices"];
    if (resultV != null) {
      //    print("diferente de null");
      resultV.forEach((element) => {vertices.add(Vertice().populate(element))});
      room.vertices = vertices;
    }

    return room;
  }
}

class Vertice {
  String id;
  String name;
  int coordX;
  int coordY;

  Vertice populate(Map<String, dynamic> dataResponse) {
    //   print("Vertice");
    //   print(dataResponse);
    var vertice = Vertice();
    vertice.name = dataResponse["name"];
    vertice.id = dataResponse["id"];
    vertice.coordX = dataResponse["coordX"];
    vertice.coordY = dataResponse["coordY"];

    /// print("Vertice2");
    return vertice;
  }
}

class Wall {
  String id;
  String name;
  int finalX;
  int height;
  int finalY;
  int initialX;
  int initialY;
  int wallType;
  List<Tube> tubes = [];

  Wall populate(Map<String, dynamic> dataResponse) {
    //  print("Wall");
    //  print(dataResponse);
    var wall = Wall();
    wall.name = dataResponse["name"];
    wall.id = dataResponse["id"];
    wall.height = dataResponse["height"];
    wall.finalX = dataResponse["finalX"];
    wall.finalY = dataResponse["finalY"];
    wall.initialX = dataResponse["initialX"];
    wall.initialY = dataResponse["initialY"];
    wall.wallType = dataResponse["wallType"];
    var result = dataResponse["tubes"];
    if (result != null) {
      result.forEach((element) => {tubes.add(Tube().populate(element))});
      wall.tubes = tubes;
    }

    return wall;
  }
}

class Tube {
  String id;
  String name;
  int finalX;
  int finalY;
  int initialX;
  int initialY;
  int tubeType;

  Tube populate(Map<String, dynamic> dataResponse) {
    //  print("Tube");
    //   print(dataResponse);
    var tube = Tube();
    tube.name = dataResponse["name"];
    tube.id = dataResponse["id"];
    tube.finalX = dataResponse["finalX"];
    tube.finalY = dataResponse["finalY"];
    tube.initialX = dataResponse["initialX"];
    tube.initialY = dataResponse["initialY"];
    tube.tubeType = dataResponse["tubeType"];
    return tube;
  }
}

class RoomProject {
  List<Line> lines = [];
  String name;
  String id;
  RoomProject({lines, name, id});
}

class Line {
  Point pointStart;
  Point pointFinish;
  Color color;
  double height = 0;
  Line(pointStart, pointFinish, {color, height}) {
    this.pointStart = pointStart;
    this.pointFinish = pointFinish;
    this.color = color;
    this.height = height;
  }
}

class Point {
  double x = 0;
  double y = 0;
  int type = 1;
  Point(x, y) {
    this.x = x;
    this.y = y;
  }

  Offset formatterCanvas(proportional, size) {
    return Offset(((x * proportional)), (size - (y * proportional)));
  }

  Offset formatterCanvas2(proportional, size) {
    return Offset(size - ((x * proportional)), (size - (y * proportional)));
  }
}
