import 'package:flutter/material.dart';
import 'package:to_do_app/screens/add_item_screen.dart';
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
        children: Globals.items
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  e["title"].toString(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
