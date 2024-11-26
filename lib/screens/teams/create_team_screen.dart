import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/teams_controller.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  CreateTeamScreenState createState() => CreateTeamScreenState();
}

class CreateTeamScreenState extends State<CreateTeamScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
        centerTitle: false,
        title: const Text(
          "Create Team",
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
              labelText: "Title",
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
              labelText: "Description",
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

                  await TeamsController.createTeam({
                    "title": titleController.text,
                    "description": descriptionController.text,
                  });

                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Create",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
