import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/teams_controller.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/screens/add_item_screen.dart';
import 'package:to_do_app/screens/edit_item_screen.dart';
import 'package:to_do_app/screens/item_media_screen.dart';
import 'package:to_do_app/screens/teams/send_team_notification_screen.dart';

class TeamScreen extends StatefulWidget {
  final int id;

  const TeamScreen({
    super.key,
    required this.id,
  });

  @override
  TeamScreenState createState() => TeamScreenState();
}

class TeamScreenState extends State<TeamScreen> {
  List<Map<String, dynamic>> items = [];

  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  Map<String, dynamic> teamData = {};

  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getTeamData();
      await getItems();
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getItems() async {
    try {
      var res = await TeamsController.getTeamItems(
        widget.id,
      );

      setState(() {
        items = res;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getTeamData() async {
    try {
      var res = await TeamsController.getTeam(widget.id);
      if (res["result"] == true) {
        setState(() {
          teamData = Map<String, dynamic>.from(
            res["data"] as Map,
          );
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
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
        centerTitle: true,
        title: Text(
          AppLocale.team_label.getString(
            context,
          ),
        ),
        actions: [
          teamData["isMine"] == true
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SendTeamNotificationScreen(teamId: widget.id);
                        },
                      ),
                    ).then((value) {
                      getData();
                    });
                  },
                  icon: const Icon(
                    Icons.notification_add,
                  ),
                )
              : Container(),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : teamData.isEmpty
              ? const Center(
                  child: Text(
                    "Team data not found!!",
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        color: Colors.blueGrey,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 60) *
                                    0.45,
                                child: Text(
                                  AppLocale.team_name_label.getString(
                                    context,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 60) *
                                    0.45,
                                child: Text(
                                  teamData["title"],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 60) *
                                    0.45,
                                child: Text(
                                  AppLocale.team_code_label.getString(
                                    context,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 60) *
                                    0.45,
                                child: Text(
                                  teamData["id"].toString(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...items.map((e) {
                      return Padding(
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
                                    width: (MediaQuery.sizeOf(context).width -
                                            60) *
                                        0.6,
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
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
                                  e["isMine"] == true
                                      ? IconButton(
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
                                                            context: context,
                                                            firstDate:
                                                                DateTime.now(),
                                                            lastDate:
                                                                DateTime.now()
                                                                    .add(
                                                              const Duration(
                                                                days: 365,
                                                              ),
                                                            ),
                                                          ).then((valueDate) {
                                                            showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay(
                                                                hour: valueDate!
                                                                    .hour,
                                                                minute:
                                                                    valueDate
                                                                        .minute,
                                                              ),
                                                            ).then((valueTime) {
                                                              // print(valueDate
                                                              //     .toIso8601String());
                                                              // print(valueTime.toString());

                                                              valueDate =
                                                                  valueDate!
                                                                      .copyWith(
                                                                hour: valueTime!
                                                                    .hour,
                                                                minute:
                                                                    valueTime
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
                                                          ScaffoldMessenger.of(
                                                                  context)
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
                                                            title: e["title"],
                                                            body: e[
                                                                "description"],
                                                            wakeUpScreen: true,
                                                            criticalAlert: true,

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
                                                            date: selectedDate!,
                                                            preciseAlarm: true,
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

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "Schedule",
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
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
                                          icon: e["scheduledNotification"] == ""
                                              ? const Icon(
                                                  Icons.alarm_add,
                                                  color: Colors.blue,
                                                )
                                              : const Icon(
                                                  Icons.history,
                                                  color: Colors.green,
                                                ),
                                        )
                                      : Container(),
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
                              e["isMine"] == true
                                  ? Row(
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
                                            visualDensity:
                                                VisualDensity.compact,
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
                                            visualDensity:
                                                VisualDensity.compact,
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
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddItemScreen(
              teamId: widget.id,
            );
          })).then((value) {
            getData();
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
