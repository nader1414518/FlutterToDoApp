import 'package:flutter/material.dart';
import 'package:to_do_app/controllers/teams_controller.dart';
import 'package:to_do_app/screens/teams/create_team_screen.dart';
import 'package:to_do_app/screens/teams/edit_team_screen.dart';

class TeamsScreen extends StatefulWidget {
  @override
  TeamsScreenState createState() => TeamsScreenState();
}

class TeamsScreenState extends State<TeamsScreen> {
  List<Map<String, dynamic>> teams = [];

  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getTeams();
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getTeams() async {
    try {
      var myTeamsRes = await TeamsController.getMyTeams();
      var joinedTeamsRes = await TeamsController.getMyJoinedTeams();

      setState(() {
        teams = [
          ...myTeamsRes,
          ...joinedTeamsRes,
        ];
      });
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
        title: const Text(
          "Teams",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...teams.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        color: Colors.blueGrey.withOpacity(
                          0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 40) *
                                    0.9,
                                child: Text(
                                  e["title"].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 40) *
                                    0.9,
                                child: Text(
                                  e["description"].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
                                          return EditTeamScreen(
                                            teamId: e["id"],
                                          );
                                        })).then(
                                          (value) {
                                            getData();
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Edit",
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Remove Item"),
                                                content: const Text(
                                                    "Are you sure you want to remove this item?"),
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      TeamsController
                                                          .removeTeam(
                                                        e["id"],
                                                      );

                                                      Navigator.of(context)
                                                          .pop();

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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text(
                                        "Remove",
                                        style: TextStyle(
                                          color: Colors.red,
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
                }).toList(),
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight * 1.25,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return CreateTeamScreen();
                },
              ),
            ).then((value) {
              getData();
            });
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
