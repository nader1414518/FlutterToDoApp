import 'package:to_do_app/utils/globals.dart';

class TodoItemsController {
  static void addToDoItem(
    Map<String, dynamic> data,
  ) async {
    Globals.items.add(data);
  }

  static List<Map<String, dynamic>> getItems() {
    return Globals.items;
  }
}
