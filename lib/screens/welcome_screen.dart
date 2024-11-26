import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/screens/core_home_screen.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/utils/assets_utils.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> checkLogin() async {
    try {
      var res = await AuthController.checkLogin();
      if (res["result"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res["message"].toString(),
            ),
          ),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CoreHomeScreen();
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res["message"].toString(),
            ),
          ),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLogin();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
          height: (MediaQuery.sizeOf(context).width - 40) * 0.6,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AssetsUtils.appLogo,
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
