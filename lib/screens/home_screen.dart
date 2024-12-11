import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/screens/add_item_screen.dart';
import 'package:to_do_app/screens/edit_item_screen.dart';
import 'package:to_do_app/screens/item_media_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/utils/globals.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];

  bool isLoading = false;

  TextEditingController searchController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await TodoItemsController.getItems();

      setState(() {
        items = res;
        filteredItems = res;
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
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
      child: Directionality(
        textDirection: localization.currentLocale.localeIdentifier == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
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
            title: Text(
              AppLocale.home_screen_label.getString(
                context,
              ),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () async {
            //       await Navigator.of(context)
            //           .push(MaterialPageRoute(builder: (context) {
            //         return AddItemScreen();
            //       })).then((value) {
            //         getData();
            //       });
            //     },
            //     icon: const Icon(
            //       Icons.add_circle_outline,
            //     ),
            //   ),
            // ],
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 180,
                    right: 10,
                    left: 10,
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
                        hintText: AppLocale.search_label.getString(
                          context,
                        ),
                        suffixIcon: const Icon(
                          Icons.search,
                        ),
                      ),
                      controller: searchController,
                      onChanged: (value) {
                        print(value);
                        if (value == "") {
                          setState(() {
                            filteredItems = items;
                          });
                          return;
                        }

                        setState(() {
                          filteredItems = items.where((element) {
                            return (element["title"]
                                    .toString()
                                    .toLowerCase()
                                    .trim()
                                    .contains(value.toLowerCase().trim()) ||
                                element["description"]
                                    .toString()
                                    .toLowerCase()
                                    .trim()
                                    .contains(value.toLowerCase().trim()));
                          }).toList();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...filteredItems
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(context).width -
                                                    60) *
                                                0.45,
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
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(context).width -
                                                    60) *
                                                0.45,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ItemMediaScreen(
                                                    id: e["id"],
                                                  );
                                                })).then((value) {
                                                  getData();
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.mediation,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  dateController.text =
                                                      e["scheduledNotification"]
                                                          .toString();
                                                });

                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Choose a time for your reminder",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  15,
                                                                ),
                                                              ),
                                                              isDense: true,
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10,
                                                              ),
                                                              labelText:
                                                                  "Date & Time",
                                                            ),
                                                            readOnly: true,
                                                            controller:
                                                                dateController,
                                                            onTap: () {
                                                              showDatePicker(
                                                                context:
                                                                    context,
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate:
                                                                    DateTime.now()
                                                                        .add(
                                                                  const Duration(
                                                                    days: 365,
                                                                  ),
                                                                ),
                                                              ).then(
                                                                  (valueDate) {
                                                                showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      TimeOfDay(
                                                                    hour: valueDate!
                                                                        .hour,
                                                                    minute: valueDate
                                                                        .minute,
                                                                  ),
                                                                ).then(
                                                                    (valueTime) {
                                                                  // print(valueDate
                                                                  //     .toIso8601String());
                                                                  // print(valueTime.toString());

                                                                  valueDate =
                                                                      valueDate!
                                                                          .copyWith(
                                                                    hour: valueTime!
                                                                        .hour,
                                                                    minute: valueTime
                                                                        .minute,
                                                                  );

                                                                  setState(() {
                                                                    selectedDate =
                                                                        valueDate;
                                                                    dateController
                                                                            .text =
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            if (selectedDate ==
                                                                null) {
                                                              ScaffoldMessenger
                                                                      .of(context)
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
                                                              content:
                                                                  NotificationContent(
                                                                id: e["id"],
                                                                channelKey:
                                                                    'basic_channel',
                                                                title:
                                                                    e["title"],
                                                                body: e[
                                                                    "description"],
                                                                wakeUpScreen:
                                                                    true,
                                                                criticalAlert:
                                                                    true,

                                                                category:
                                                                    NotificationCategory
                                                                        .Alarm,
                                                                notificationLayout:
                                                                    NotificationLayout
                                                                        .BigText,
                                                                // bigPicture:
                                                                //     'asset://assets/images/delivery.jpeg',
                                                                // payload: {
                                                                //   'uuid': 'uuid-test'
                                                                // },
                                                                autoDismissible:
                                                                    false,
                                                              ),
                                                              schedule:
                                                                  NotificationCalendar
                                                                      .fromDate(
                                                                date:
                                                                    selectedDate!,
                                                                preciseAlarm:
                                                                    true,
                                                                allowWhileIdle:
                                                                    true,
                                                              ),
                                                            );

                                                            await TodoItemsController
                                                                .updateScheduledNotification(
                                                              e["id"],
                                                              selectedDate!
                                                                  .toIso8601String(),
                                                            );

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            "Schedule",
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
                                              icon:
                                                  e["scheduledNotification"] ==
                                                          ""
                                                      ? const Icon(
                                                          Icons.alarm_add,
                                                          color: Colors.blue,
                                                        )
                                                      : const Icon(
                                                          Icons.history,
                                                          color: Colors.green,
                                                        ),
                                            ),
                                            e["isFavorite"] == false
                                                ? IconButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      try {
                                                        var res =
                                                            await TodoItemsController
                                                                .addToFavorites(
                                                          e["id"],
                                                        );

                                                        if (res["result"] ==
                                                            true) {
                                                          getData();
                                                        }
                                                      } catch (e) {
                                                        print(e.toString());
                                                      }

                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.favorite_border,
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      try {
                                                        var res =
                                                            await TodoItemsController
                                                                .removeFromFavorites(
                                                          e["id"],
                                                        );

                                                        if (res["result"] ==
                                                            true) {
                                                          getData();
                                                        }
                                                      } catch (e) {
                                                        print(e.toString());
                                                      }

                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.favorite,
                                                    ),
                                                  ),
                                          ],
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
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
                                          foregroundColor:
                                              WidgetStateProperty.all(
                                            Colors.white,
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                5,
                                              ),
                                            ),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        child: Text(
                                          AppLocale.edit_label.getString(
                                            context,
                                          ),
                                          style: const TextStyle(
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
                                                title: Text(
                                                  AppLocale.remove_item_label
                                                      .getString(
                                                    context,
                                                  ),
                                                ),
                                                content: Text(
                                                  AppLocale.remove_item_desc
                                                      .getString(
                                                    context,
                                                  ),
                                                ),
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      TodoItemsController
                                                          .removeItem(
                                                        e["id"],
                                                      );

                                                      Navigator.of(context)
                                                          .pop();

                                                      getData();
                                                    },
                                                    child: Text(
                                                      AppLocale.remove_label
                                                          .getString(
                                                        context,
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      AppLocale.cancel_label
                                                          .getString(
                                                        context,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStateProperty.all(
                                            Colors.white,
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                5,
                                              ),
                                            ),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        child: Text(
                                          AppLocale.remove_label.getString(
                                            context,
                                          ),
                                          style: const TextStyle(
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
                        .toList()
                  ],
                ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(
              bottom: kBottomNavigationBarHeight * 1.25,
            ),
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddItemScreen();
                })).then((value) {
                  getData();
                });
              },
              child: const Icon(
                Icons.add,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
