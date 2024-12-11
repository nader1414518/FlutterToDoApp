import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';

class AddItemScreen extends StatefulWidget {
  int? teamId;

  AddItemScreen({super.key, this.teamId});

  @override
  AddItemScreenState createState() => AddItemScreenState();
}

class AddItemScreenState extends State<AddItemScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocale.add_item_label.getString(
            context,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
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
                  await TodoItemsController.addToDoItem({
                    "title": titleController.text,
                    "description": descriptionController.text,
                    "teamId": widget.teamId,
                  });

                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocale.add_label.getString(
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
