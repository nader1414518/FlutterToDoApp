import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';
import 'package:to_do_app/utils/globals.dart';

class EditItemScreen extends StatefulWidget {
  final int id;

  const EditItemScreen({
    super.key,
    required this.id,
  });

  @override
  EditItemScreenState createState() => EditItemScreenState();
}

class EditItemScreenState extends State<EditItemScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> getData() async {
    try {
      // var item =
      //     Globals.items.firstWhere((element) => element["id"] == widget.id);

      var itemRes = await TodoItemsController.getItem(widget.id);
      if (itemRes["result"] == true) {
        var item = Map<String, dynamic>.from(
          itemRes["data"] as Map,
        );

        setState(() {
          titleController.text = item["title"].toString();
          descriptionController.text = item["description"].toString();
        });
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Item",
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
                  await TodoItemsController.editItem(widget.id, {
                    "title": titleController.text,
                    "description": descriptionController.text,
                  });

                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Edit",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
