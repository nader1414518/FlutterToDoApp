import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/controllers/auth_controller.dart';

class TeamsController {
  static Future<Map<String, dynamic>> createTeam(
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

      data["leaderId"] = uid;
      data["addedBy"] = uid;
      data["active"] = true;
      data["archived"] = false;
      data["dateAdded"] = DateTime.now().toIso8601String();

      await Supabase.instance.client.from("teams").insert(
            data,
          );

      return {
        "result": true,
        "message": "Created successfully ... ",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> updateTeam(
    int id,
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

      data["updatedBy"] = uid;
      data["dateUpdated"] = DateTime.now().toIso8601String();

      await Supabase.instance.client
          .from("teams")
          .update(
            data,
          )
          .eq("id", id);

      return {
        "result": true,
        "message": "Updated successfully ... ",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> removeTeam(
    int id,
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

      Map<String, dynamic> data = {};

      data["active"] = false;
      data["updatedBy"] = uid;
      data["dateUpdated"] = DateTime.now().toIso8601String();

      await Supabase.instance.client
          .from("teams")
          .update(
            data,
          )
          .eq("id", id);

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

  static Future<List<Map<String, dynamic>>> getMyTeams() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return [];
      }

      var res = await Supabase.instance.client
          .from("teams")
          .select()
          .eq("leaderId", uid)
          .eq("active", true);

      return res.map((e) {
        return {
          ...e,
          "isMine": true,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getTeam(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      var res =
          await Supabase.instance.client.from("teams").select().eq("id", id);

      if (res.isEmpty) {
        return {
          "result": false,
          "message": "Team not found!!",
        };
      }

      var data = res.first;
      if (data["leaderId"] == uid) {
        data["isMine"] = true;
      } else {
        data["isMine"] = false;
      }

      return {
        "result": true,
        "message": "Retrieved successfully ... ",
        "data": data,
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> addItemToTeam(
    int teamId,
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

      var teamRes = await getTeam(teamId);
      if (teamRes["result"] == false) {
        return teamRes;
      }

      data["active"] = true;
      data["teamId"] = teamId;
      data["addedBy"] = uid;
      data["dateAdded"] = DateTime.now().toIso8601String();
      data["userId"] = uid;

      await Supabase.instance.client.from("todos").insert(
            data,
          );

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

  static Future<List<Map<String, dynamic>>> getTeamItems(int teamId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return [];
      }

      var res = await Supabase.instance.client
          .from("todos")
          .select()
          .eq("teamId", teamId)
          .eq("active", true);

      return res.map((e) {
        if (e["userId"] == uid) {
          e["isMine"] = true;
        } else {
          e["isMine"] = false;
        }

        return e;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> joinTeam(int teamId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      var teamRes = await getTeam(teamId);
      if (teamRes["result"] == false) {
        return teamRes;
      }

      var userTeamRes = await Supabase.instance.client
          .from("users_teams")
          .select()
          .eq("userId", uid)
          .eq("teamId", teamId);
      if (userTeamRes.isNotEmpty) {
        return {
          "result": false,
          "message": "You already joined this team!!",
        };
      }

      await Supabase.instance.client.from("users_teams").insert({
        "userId": uid,
        "teamId": teamId,
      });

      return {
        "result": true,
        "message": "Joined successfully ... ",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> leaveTeam(int teamId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      var teamRes = await getTeam(teamId);
      if (teamRes["result"] == false) {
        return teamRes;
      }

      var userTeamRes = await Supabase.instance.client
          .from("users_teams")
          .select()
          .eq("userId", uid)
          .eq("teamId", teamId);
      if (userTeamRes.isEmpty) {
        return {
          "result": false,
          "message": "You are already not a member of this team!!",
        };
      }

      await Supabase.instance.client
          .from("users_teams")
          .delete()
          .eq("userId", uid)
          .eq("teamId", teamId);

      return {
        "result": true,
        "message": "Left successfully ... ",
      };
    } catch (e) {
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getMyJoinedTeams() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var uid = prefs.getString("uid") ?? "";
      if (uid == "") {
        return [];
      }

      var usersTeamsRes = await Supabase.instance.client
          .from("users_teams")
          .select()
          .eq("userId", uid);
      List<int> teamIds = [];
      for (var userTeam in usersTeamsRes) {
        teamIds.add(userTeam["teamId"]);
      }

      var teamsRes = await Supabase.instance.client
          .from("teams")
          .select()
          .inFilter("id", teamIds)
          .eq("active", true);

      return teamsRes.map((e) {
        return {
          ...e,
          "isMine": false,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<String>> getTeamMembers(int teamId) async {
    try {
      var userTeamRes = await Supabase.instance.client
          .from("users_teams")
          .select()
          .eq("teamId", teamId);

      return userTeamRes.map((e) => e["userId"].toString()).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> sendNotificationToMembers(
    int teamId,
    String title,
    String body,
  ) async {
    try {
      var membersUIDs = await getTeamMembers(teamId);

      for (var uid in membersUIDs) {
        // Send notification
        var tokenRes = await http.get(
          Uri.parse("${dotenv.env["CLOUD_API"]}/api/generate_fcm_token"),
          headers: {
            "Authorization": "Bearer ${dotenv.env["FCM_SERVER_KEY_V2"]}",
          },
        );

        var tokenResResult = Map<String, dynamic>.from(
          jsonDecode(tokenRes.body) as Map,
        );
        if (tokenResResult["result"] == true) {
          var accessToken = tokenResResult["token"].toString();

          // print(accessToken);

          String userToken = "";
          var userDataRes = await AuthController.getCurrentUserData();
          if (userDataRes["result"] == true) {
            userToken = userDataRes["data"]["user_metadata"]["token"];
          }

          var sendRes = await http.post(
            Uri.parse("${dotenv.env["FCM_SEND_URL_V2"]}"),
            headers: <String, String>{
              "Content-Type": "application/json",
              "Authorization": "Bearer $accessToken",
            },
            body: jsonEncode(
              <String, dynamic>{
                "message": {
                  "token": userToken,
                  "notification": {
                    "title": title,
                    "body": body,
                  },
                  "data": {},
                }
              },
            ),
          );

          if (sendRes.statusCode == 200) {
            continue;
          } else {
            print(sendRes.body);
            return {
              "result": false,
              "message": "Error ${sendRes.statusCode}",
            };
          }
        } else {
          return tokenResResult;
        }
      }

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
}
