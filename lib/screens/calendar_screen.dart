import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_app/controllers/todo_items_controller.dart';

class CalendarScreen extends StatefulWidget {
  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  List<Map<String, dynamic>> events = [];

  bool isLoading = false;

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  List<Map<String, dynamic>> selectedEvents = [];

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await TodoItemsController.getItems();

      setState(() {
        events = res.where((element) {
          return element["scheduledNotification"] != "";
        }).map((element) {
          return {
            "id": element["id"],
            "title": element["title"],
            "description": element["description"],
            "date": element["scheduledNotification"],
          };
        }).toList();
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
        title: const Text(
          "Calendar",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          TableCalendar(
            daysOfWeekVisible: true,
            locale: "ar_EG",
            firstDay: DateTime.now().subtract(
              const Duration(
                days: 1200,
              ),
            ),
            lastDay: DateTime.now().add(
              const Duration(
                days: 1200,
              ),
            ),
            weekendDays: [],
            calendarStyle: CalendarStyle(
              cellPadding: const EdgeInsets.all(5),
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              markerSize: 5,
              todayDecoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(
                  0.5,
                ),
                // borderRadius: BorderRadius.circular(
                //   30,
                // ),
              ),
              tableBorder: TableBorder(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                top: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                bottom: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                left: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
                right: const BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
            ),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              List<Map<String, dynamic>> targetEvents = [];
              for (var ev in events) {
                var evDate = DateTime.parse(
                  ev["date"].toString(),
                ).copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                );

                if (isSameDay(evDate, selectedDay)) {
                  targetEvents.add(ev);
                }
              }

              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                selectedEvents = targetEvents;
              });

              // print(targetEvents);
            },
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              List<Map<String, dynamic>> targetEvents = [];
              for (var ev in events) {
                var evDate = DateTime.parse(
                  ev["date"].toString(),
                ).copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                );

                if (isSameDay(evDate, day)) {
                  targetEvents.add(ev);
                }
              }

              // setState(() {
              //   targetEvents;
              // });

              return targetEvents;
            },
            onPageChanged: (focusedDay) {
              // _focusedDay = focusedDay;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...selectedEvents.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width:
                                  (MediaQuery.sizeOf(context).width - 60) * 0.9,
                              child: Text(
                                e["title"].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width:
                                  (MediaQuery.sizeOf(context).width - 60) * 0.9,
                              child: Text(
                                e["description"].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
