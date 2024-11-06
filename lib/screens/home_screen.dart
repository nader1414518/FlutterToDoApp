import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';
import 'package:to_do_app/screens/add_item_screen.dart';
import 'package:to_do_app/screens/edit_item_screen.dart';
import 'package:to_do_app/utils/globals.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    print("Hello from Init State ... ");
    // TODO: implement initState
    super.initState();

    items = Globals.items;
  }

  @override
  void dispose() {
    print("Hello from dispose ... ");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Screen",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return AddItemScreen();
              }));

              setState(() {
                items = Globals.items;
              });
            },
            icon: const Icon(
              Icons.add_circle_outline,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(
                      0.3,
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e["title"].toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        e["description"].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return EditItemScreen(
                                  id: e["id"],
                                );
                              })).then(
                                (value) {
                                  setState(() {
                                    items = Globals.items;
                                  });
                                },
                              );
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                Colors.blue,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                              ),
                              elevation: WidgetStateProperty.all(
                                10,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Remove Item"),
                                      content: const Text(
                                          "Are you sure you want to remove this item?"),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            TodoItemsController.removeItem(
                                              e["id"],
                                            );

                                            Navigator.of(context).pop();

                                            setState(() {
                                              items = Globals.items;
                                            });
                                          },
                                          child: const Text(
                                            "Remove",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Cancel",
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                Colors.red,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                              ),
                              elevation: WidgetStateProperty.all(
                                10,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text(
                              "Remove",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
