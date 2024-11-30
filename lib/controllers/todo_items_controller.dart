import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_app/utils/globals.dart';

class TodoItemsController {
  static Future<Map<String, dynamic>> addToDoItem(
    Map<String, dynamic> data,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var uid = prefs.getString("uid") ?? "";

      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      data["dateAdded"] = DateTime.now().toIso8601String();
      data["active"] = true;
      data["archived"] = false;
      data["userId"] = uid;
      data["addedBy"] = uid;

      await Supabase.instance.client.from("todos").insert(data);

      return {
        "result": true,
        "message": "Added successfully ... ",
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";

      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      data["dateUpdated"] = DateTime.now().toIso8601String();
      data["updatedBy"] = uid;

      await Supabase.instance.client.from("todos").update(data).eq("id", id);

      return {
        "result": true,
        "message": "Updated successfully .. ",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> removeItem(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";

      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("todos").update({
        "active": false,
        "dateUpdated": DateTime.now().toIso8601String(),
        "updatedBy": uid,
      }).eq("id", id);

      return {
        "result": true,
        "message": "Removed successfully ... ",
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
      var data = await Supabase.instance.client
          .from("todos")
          .select()
          .eq("id", id)
          .eq("active", true);
      if (data.isEmpty) {
        return {
          "result": false,
          "message": "No item found!!",
        };
      }

      var item = data.first;

      return {
        "result": true,
        "message": "Retrieved successfully ... ",
        "data": item,
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";

      if (uid == "") {
        return [];
      }

      var data = await Supabase.instance.client
          .from("todos")
          .select()
          .eq("userId", uid)
          .eq("active", true)
          .isFilter("teamId", null);
      if (data.isEmpty) {
        return [];
      }

      return data;
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateScheduledNotification(
      int id, String isoDate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";

      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("todos").update({
        "scheduledNotification": isoDate,
        "updatedBy": uid,
        "dateUpdated": DateTime.now().toIso8601String(),
      }).eq("id", id);

      return {
        "result": true,
        "message": "Scheduled successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }
}
