import 'package:to_do_app/utils/globals.dart';

class TodoItemsController {
  static void addToDoItem(
    Map<String, dynamic> data,
  ) async {
    data["id"] = Globals.items.length;

    Globals.items.add(data);
  }

  static void editItem(int id, Map<String, dynamic> data) async {
    var items = Globals.items;
    for (int i = 0; i < items.length; i++) {
      if (items[i]["id"] == id) {
        items[i]["title"] = data["title"];
        items[i]["description"] = data["description"];
        break;
      }
    }

    Globals.items = items;
  }

  static void removeItem(int id) async {
    Globals.items =
        Globals.items.where((element) => element["id"] != id).toList();
  }

  static List<Map<String, dynamic>> getItems() {
    return Globals.items;
  }
}
