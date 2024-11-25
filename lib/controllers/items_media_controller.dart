import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemsMediaController {
  static Future<Map<String, dynamic>> storeMediaToItem(
      Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      data["active"] = true;
      data["dateAdded"] = DateTime.now().toIso8601String();
      data["addedBy"] = uid;

      await Supabase.instance.client.from("todos_media").insert(
            data,
          );

      return {
        "result": true,
        "message": "Stored successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getItemMedia(int itemId) async {
    try {
      var res = await Supabase.instance.client
          .from("todos_media")
          .select()
          .eq("item_id", itemId)
          .eq("active", true);

      return res;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> removeMedia(int mediaId) async {
    try {
      var res = await Supabase.instance.client.from("todos_media").update({
        "active": false,
      }).eq("id", mediaId);

      return {
        "result": true,
        "message": "Removed successfully ... ",
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
