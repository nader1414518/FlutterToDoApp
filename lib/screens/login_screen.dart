import 'package:flutter/material.dart';
import 'package:to_do_app/screens/create_account_screen.dart';
import 'package:to_do_app/utils/assets_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
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
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              labelText: "Email",
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              labelText: "Password",
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
            ),
            obscureText: true,
            controller: passController,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Sign In"),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateAccountScreen();
                      },
                    ),
                  );
                },
                child: const Text("Create Account"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
