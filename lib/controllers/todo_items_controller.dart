import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/utils/globals.dart';

class TodoItemsController {
  static Future<Map<String, dynamic>> addToDoItem(
    Map<String, dynamic> data,
  ) async {
    // data["id"] = Globals.items.length;

    // Globals.items.add(data);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> items = prefs.getStringList("todo_items") ?? [];

      data["id"] = items.length;

      String serializedItem = jsonEncode(data);

      items.add(
        serializedItem,
      );

      await prefs.setStringList("todo_items", items);

      return {
        "result": true,
        "message": "Success",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> editItem(
      int id, Map<String, dynamic> data) async {
    // var items = Globals.items;
    // for (int i = 0; i < items.length; i++) {
    //   if (items[i]["id"] == id) {
    //     items[i]["title"] = data["title"];
    //     items[i]["description"] = data["description"];
    //     break;
    //   }
    // }

    // Globals.items = items;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> items = prefs.getStringList("todo_items") ?? [];

      for (int i = 0; i < items.length; i++) {
        Map<String, dynamic> deserializedItem = Map<String, dynamic>.from(
          jsonDecode(items[i]) as Map,
        );

        if (deserializedItem["id"] == id) {
          items[i] = jsonEncode({
            ...deserializedItem,
            ...data,
          });
          break;
        }
      }

      await prefs.setStringList("todo_items", items);

      return {
        "result": true,
        "message": "Success",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> removeItem(int id) async {
    // Globals.items =
    //     Globals.items.where((element) => element["id"] != id).toList();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> items = prefs.getStringList("todo_items") ?? [];

      items = items
          .map((element) => Map<String, dynamic>.from(
                jsonDecode(element) as Map,
              ))
          .where((element) => element["id"] != id)
          .map((element) => jsonEncode(element))
          .toList();

      await prefs.setStringList("todo_items", items);

      return {
        "result": true,
        "message": "Success",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getItem(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> items = prefs.getStringList("todo_items") ?? [];

      var item = items.firstWhere((element) =>
          Map<String, dynamic>.from(jsonDecode(element) as Map)["id"] == id);

      return {
        "result": true,
        "message": "Success",
        "data": Map<String, dynamic>.from(
          jsonDecode(item) as Map,
        ),
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    // return Globals.items;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> items = prefs.getStringList("todo_items") ?? [];

      return items
          .map(
            (element) => Map<String, dynamic>.from(
              jsonDecode(element) as Map,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}
