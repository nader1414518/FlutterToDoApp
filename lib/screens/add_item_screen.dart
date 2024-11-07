import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';

class AddItemScreen extends StatefulWidget {
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
        title: const Text(
          "Add Item",
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
                  await TodoItemsController.addToDoItem({
                    "title": titleController.text,
                    "description": descriptionController.text,
                  });

                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Add",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
