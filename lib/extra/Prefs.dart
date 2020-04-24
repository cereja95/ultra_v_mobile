import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  init() {}
  setPrefString(String key, String value) async {
//   SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getPrefString(String key) async {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }
}
