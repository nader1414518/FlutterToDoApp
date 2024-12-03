import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/utils/assets_utils.dart';

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
          Container(
            padding: const EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.sizeOf(context).width - 60) * 0.3,
                  height: (MediaQuery.sizeOf(context).width - 60) * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AssetsUtils.appLogo,
                      ),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 60) * 0.6,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text(
                  "Change My Email",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text(
                  "Change My Password",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
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
