import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  Function(bool) toggleNavbar;

  ProfileScreen({
    super.key,
    required this.toggleNavbar,
  });

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.red,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    Colors.white,
                  ),
                ),
                onPressed: () async {
                  try {
                    await AuthController.logout();
                  } catch (e) {
                    print(e.toString());
                  }

                  widget.toggleNavbar(false);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: const Text(
                  "Log Out",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
