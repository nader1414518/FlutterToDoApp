import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/teams_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';

class EditTeamScreen extends StatefulWidget {
  final int teamId;

  const EditTeamScreen({
    super.key,
    required this.teamId,
  });

  @override
  EditTeamScreenState createState() => EditTeamScreenState();
}

class EditTeamScreenState extends State<EditTeamScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await TeamsController.getTeam(widget.teamId);

      if (res["result"] == true) {
        setState(() {
          titleController.text = res["data"]["title"].toString();
          descriptionController.text = res["data"]["description"].toString();
        });
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).pop();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
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
        centerTitle: false,
        title: Text(
          AppLocale.edit_label.getString(
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
                    labelText: AppLocale.title_label.getString(
                      context,
                    ),
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
                    isDense: true,
                    contentPadding: const EdgeInsets.all(
                      10,
                    ),
                    labelText: AppLocale.description_label.getString(
                      context,
                    ),
                  ),
                  minLines: 1,
                  maxLines: 10,
                  controller: descriptionController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (titleController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter title ... ",
                              ),
                            ),
                          );
                          return;
                        }

                        await TeamsController.updateTeam(widget.teamId, {
                          "title": titleController.text,
                          "description": descriptionController.text,
                        });

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocale.edit_label.getString(
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
