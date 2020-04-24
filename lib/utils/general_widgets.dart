import 'package:flutter/material.dart';
import 'color.dart';

Widget navBarGeneral({bool back = false}) {
  return AppBar(
    automaticallyImplyLeading: back,
    title: Container(
        height: 40, child: Image.asset('assets/logo2.png', fit: BoxFit.cover)),
    backgroundColor: HexColor("#333333"),
  );
}

Widget placeGeneral(title) {
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

Widget txtModalGeneral(name, controller, {TextInputType keyboardType}) {
  return Expanded(
      child: Container(
    margin: EdgeInsets.only(top: 15, left: 10, right: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: Colors.grey)),
    child: TextField(
      keyboardType: keyboardType,
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

Widget txtModalGeneral2(name, controller, {TextInputType keyboardType}) {
  return Expanded(
      child: Container(
    margin: EdgeInsets.only(top: 15, left: 10, right: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: HexColor("#DDDDDD"))),
    child: TextField(
      keyboardType: keyboardType,
      maxLines: null,
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
