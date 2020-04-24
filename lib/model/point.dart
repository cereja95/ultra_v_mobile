import 'package:flutter/material.dart';

class Point {
  double x = 0;
  double y = 0;
  String id;
  Point(x, y, {id}) {
    this.x = x;
    this.y = y;
    this.id = id;
  }

  Offset formatterCanvas(proportional, size) {
    return Offset(((x * proportional)), (size - (y * proportional)));
  }
}

class Line {
  Point pointStart;
  Point pointFinish;
  Color color;
  String id;
  Line(pointStart, pointFinish, {color, String id}) {
    this.pointStart = pointStart;
    this.pointFinish = pointFinish;
    this.color = color;
    this.id = id;
  }
}

class Room {
  List<Line> lines = [];
  String name;
  Room({lines, name});
}

class RoomProject {
  List<Line> lines = [];
  String name;
  String id;
  RoomProject({lines, name, id});
}

class PlanBase {
  List<Room> rooms = [];
  String name;
}
