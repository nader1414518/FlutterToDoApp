import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/teams_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';

class JoinTeamScreen extends StatefulWidget {
  @override
  JoinTeamScreenState createState() => JoinTeamScreenState();
}

class JoinTeamScreenState extends State<JoinTeamScreen> {
  TextEditingController codeController = TextEditingController();

  bool isLoading = false;

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
        centerTitle: true,
        title: Text(
          AppLocale.join_team_label.getString(
            context,
          ),
        ),
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
                    isDense: true,
                    contentPadding: const EdgeInsets.all(
                      10,
                    ),
                    labelText: AppLocale.team_code_label.getString(
                      context,
                    ),
                  ),
                  controller: codeController,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        if (codeController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter join code ... ",
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          var res = await TeamsController.joinTeam(
                            num.parse(codeController.text).toInt(),
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
                        AppLocale.join_label.getString(
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
