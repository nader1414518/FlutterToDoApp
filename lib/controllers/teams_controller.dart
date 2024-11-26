import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      var res =
          await Supabase.instance.client.from("teams").select().eq("id", id);

      if (res.isEmpty) {
        return {
          "result": false,
          "message": "Team not found!!",
        };
      }

      return {
        "result": true,
        "message": "Retrieved successfully ... ",
        "data": res.first,
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
      var res = await Supabase.instance.client
          .from("todos")
          .select()
          .eq("teamId", teamId)
          .eq("active", true);

      return res;
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
}
