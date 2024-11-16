import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: dotenv.env["GOOGLE_ANDROID_CLIENT_ID"].toString(),
        serverClientId: dotenv.env["GOOGLE_WEB_CLIENT_ID"].toString(),
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool("is_logged_in", true);
      await prefs.setString("login_method", "Google");
      await prefs.setString("login_email", response.user!.email!);
      await prefs.setString("login_password", "");
      await prefs.setString("uid", response.user!.id);

      return {
        "result": true,
        "message": "Signed in successfully ... ",
      };
    } on AuthException catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> data,
  ) async {
    try {
      var res = await Supabase.instance.client.auth.signUp(
        password: data["password"].toString(),
        email: data["email"].toString().toLowerCase().trim(),
        data: {
          ...data,
        },
      );

      if (res.user == null) {
        return {
          "result": false,
          "message": "Something went wrong!!",
        };
      }

      var user = res.user;

      return {
        "result": true,
        "message": "Account created successfully ... ",
        "data": user!.toJson(),
      };
    } on AuthException catch (e) {
      print(e.message.toString());
      return {
        "result": false,
        "message": e.message.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      var res = await Supabase.instance.client.auth.signInWithPassword(
        password: password,
        email: email.toLowerCase().trim(),
      );

      if (res.user == null) {
        return {
          "result": false,
          "message": "Something went wrong!!",
        };
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool("is_logged_in", true);
      await prefs.setString("login_method", "Email");
      await prefs.setString("login_email", email.toLowerCase().trim());
      await prefs.setString("login_password", password);
      await prefs.setString("uid", res.user!.id);

      return {
        "result": true,
        "message": "Logged in successfully ... ",
      };
    } on AuthException catch (e) {
      print(e.message.toString());
      return {
        "result": false,
        "message": e.message.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> checkLogin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var isLoggedIn = prefs.getBool("is_logged_in") ?? false;
      if (isLoggedIn) {
        var method = prefs.getString("login_method");
        if (method == "Email") {
          var email = prefs.getString("login_email");
          var password = prefs.getString("login_password");

          var loginRes = await login(
            email!,
            password!,
          );

          return loginRes;
        } else if (method == "Google") {
          var loginRes = await signInWithGoogle();

          return loginRes;
        } else {
          return {
            "result": true,
            "message": "Welcome again!!",
          };
        }
      } else {
        return {
          "result": false,
          "message": "Please login with your account!!",
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      print(e.toString());
    }

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: dotenv.env["GOOGLE_ANDROID_CLIENT_ID"].toString(),
        serverClientId: dotenv.env["GOOGLE_WEB_CLIENT_ID"].toString(),
      );

      final googleUser = await googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.remove("is_logged_in");
      await prefs.remove("login_email");
      await prefs.remove("login_password");
      await prefs.remove("uid");
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Map<String, dynamic>> forgotPasswordCallback(
      String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);

      return {
        "result": true,
        "message": "Link has been sent successfully to your email!!",
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
