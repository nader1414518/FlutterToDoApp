import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';
import 'package:to_do_app/screens/add_item_screen.dart';
import 'package:to_do_app/screens/edit_item_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/utils/globals.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = [];

  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  Future<void> getData() async {
    try {
      var res = await TodoItemsController.getItems();

      setState(() {
        items = res;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    print("Hello from Init State ... ");
    // TODO: implement initState
    super.initState();

    // items = Globals.items;
    getData();
  }

  @override
  void dispose() {
    print("Hello from dispose ... ");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await AuthController.logout();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
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
                })).then((value) {
                  getData();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                                  (MediaQuery.sizeOf(context).width - 60) * 0.6,
                              child: Text(
                                e["title"].toString(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  dateController.text =
                                      e["scheduledNotification"].toString();
                                });

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "Choose a time for your reminder",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  15,
                                                ),
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10,
                                              ),
                                              labelText: "Date & Time",
                                            ),
                                            readOnly: true,
                                            controller: dateController,
                                            onTap: () {
                                              showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                  const Duration(
                                                    days: 365,
                                                  ),
                                                ),
                                              ).then((valueDate) {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                    hour: valueDate!.hour,
                                                    minute: valueDate.minute,
                                                  ),
                                                ).then((valueTime) {
                                                  // print(valueDate
                                                  //     .toIso8601String());
                                                  // print(valueTime.toString());

                                                  valueDate =
                                                      valueDate!.copyWith(
                                                    hour: valueTime!.hour,
                                                    minute: valueTime.minute,
                                                  );

                                                  setState(() {
                                                    selectedDate = valueDate;
                                                    dateController.text =
                                                        selectedDate!
                                                            .toIso8601String();
                                                  });
                                                });
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            if (selectedDate == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Please select a date",
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            await AwesomeNotifications()
                                                .createNotification(
                                              content: NotificationContent(
                                                id: e["id"],
                                                channelKey: 'basic_channel',
                                                title: e["title"],
                                                body: e["description"],
                                                wakeUpScreen: true,
                                                criticalAlert: true,

                                                category:
                                                    NotificationCategory.Alarm,
                                                notificationLayout:
                                                    NotificationLayout.BigText,
                                                // bigPicture:
                                                //     'asset://assets/images/delivery.jpeg',
                                                // payload: {
                                                //   'uuid': 'uuid-test'
                                                // },
                                                autoDismissible: false,
                                              ),
                                              schedule:
                                                  NotificationCalendar.fromDate(
                                                date: selectedDate!,
                                                preciseAlarm: true,
                                                allowWhileIdle: true,
                                              ),
                                            );

                                            await TodoItemsController
                                                .updateScheduledNotification(
                                              e["id"],
                                              selectedDate!.toIso8601String(),
                                            );

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Schedule",
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
                                  },
                                );
                              },
                              icon: e["scheduledNotification"] == ""
                                  ? const Icon(
                                      Icons.alarm_add,
                                      color: Colors.blue,
                                    )
                                  : const Icon(
                                      Icons.history,
                                      color: Colors.green,
                                    ),
                            ),
                          ],
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
                                    getData();
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

                                              getData();
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
      ),
    );
  }
}
