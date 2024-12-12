import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/teams_controller.dart';

class SendTeamNotificationScreen extends StatefulWidget {
  final int teamId;

  const SendTeamNotificationScreen({
    super.key,
    required this.teamId,
  });

  @override
  SendTeamNotificationScreenState createState() =>
      SendTeamNotificationScreenState();
}

class SendTeamNotificationScreenState
    extends State<SendTeamNotificationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
        title: const Text(
          "Send Notification",
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
                    labelText: "Title",
                    contentPadding: const EdgeInsets.all(
                      10,
                    ),
                    isDense: true,
                  ),
                  controller: titleController,
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
                    labelText: "Body",
                    contentPadding: const EdgeInsets.all(
                      10,
                    ),
                    isDense: true,
                  ),
                  controller: descriptionController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          var res =
                              await TeamsController.sendNotificationToMembers(
                            widget.teamId,
                            titleController.text,
                            descriptionController.text,
                          );

                          if (res["result"] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Sent Successfully ... ",
                                ),
                              ),
                            );

                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res["message"].toString(),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e.toString());
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: const Text(
                        "Send",
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
