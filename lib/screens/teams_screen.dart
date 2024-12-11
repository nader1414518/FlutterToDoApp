import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:to_do_app/controllers/teams_controller.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/screens/teams/create_team_screen.dart';
import 'package:to_do_app/screens/teams/edit_team_screen.dart';
import 'package:to_do_app/screens/teams/join_team_screen.dart';
import 'package:to_do_app/screens/teams/team_screen.dart';

class TeamsScreen extends StatefulWidget {
  Function(bool) toggleNavbar;

  TeamsScreen({
    super.key,
    required this.toggleNavbar,
  });

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
        title: Text(
          AppLocale.teams_label.getString(
            context,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.toggleNavbar(false);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return JoinTeamScreen();
                  },
                ),
              ).then((value) {
                widget.toggleNavbar(true);
                getData();
              });
            },
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
                    child: InkWell(
                      onTap: () {
                        widget.toggleNavbar(false);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return TeamScreen(
                            id: e["id"],
                          );
                        })).then((value) {
                          widget.toggleNavbar(true);
                          getData();
                        });
                      },
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
                                  width:
                                      (MediaQuery.sizeOf(context).width - 40) *
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
                                  width:
                                      (MediaQuery.sizeOf(context).width - 40) *
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
                                        child: Text(
                                          AppLocale.edit_label.getString(
                                            context,
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
                                                        TeamsController
                                                            .removeTeam(
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
                                              });
                                        },
                                        child: Text(
                                          AppLocale.remove_label.getString(
                                            context,
                                          ),
                                          style: const TextStyle(
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
