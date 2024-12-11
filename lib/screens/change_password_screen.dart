import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isLoading = false;
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
      appBar: AppBar(
        title: Text(
          AppLocale.change_password_label.getString(
            context,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    isDense: true,
                    labelText: AppLocale.new_password_label.getString(
                      context,
                    ),
                  ),
                  obscureText: true,
                  controller: passController,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        if (passController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter new password!!",
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          var res = await AuthController.updateUserPassword(
                            passController.text,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                res["message"].toString(),
                              ),
                            ),
                          );

                          if (res["result"] == true) {
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          print(e.toString());
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text(
                        AppLocale.update_label.getString(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
