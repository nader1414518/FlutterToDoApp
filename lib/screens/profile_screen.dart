import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_app/controllers/auth_controller.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/screens/change_email_screen.dart';
import 'package:to_do_app/screens/change_password_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/utils/assets_utils.dart';

class ProfileScreen extends StatefulWidget {
  Function(bool) toggleNavbar;

  ProfileScreen({
    super.key,
    required this.toggleNavbar,
  });

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  String email = "";
  String phone = "";
  String fullName = "";
  String avatarUrl = "";

  List<String> locales = [
    "English",
    "العربية",
  ];

  String? currentLocale;

  Map<String, dynamic> currentUserData = {};

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var langCode = localization.currentLocale!.languageCode;
      if (langCode == "en") {
        setState(() {
          currentLocale = "English";
        });
      } else if (langCode == "ar") {
        setState(() {
          currentLocale = "العربية";
        });
      }

      var res = await AuthController.getCurrentUserData();
      if (res["result"] == true) {
        var userMetadata = Map<String, dynamic>.from(
          res["data"]["user_metadata"] as Map,
        );

        // print(res["data"]);

        setState(() {
          if (res["data"]["new_email"] == null) {
            email = res["data"]["email"].toString();
          } else {
            email = res["data"]["new_email"].toString();
          }
          phone = userMetadata["phone"] == null
              ? ""
              : userMetadata["phone"].toString();
          avatarUrl = userMetadata["photoUrl"] == null
              ? ""
              : userMetadata["photoUrl"].toString();
          fullName = userMetadata["full_name"] == null
              ? ""
              : userMetadata["full_name"].toString();

          currentUserData = userMetadata;
        });
      }
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

    currentLocale = locales.first;

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
          "Profile",
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentUserData.isEmpty
              ? const Center(
                  child: Text("User not found!!"),
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
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              width:
                                  (MediaQuery.sizeOf(context).width - 60) * 0.3,
                              height:
                                  (MediaQuery.sizeOf(context).width - 60) * 0.3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: avatarUrl == ""
                                      ? AssetImage(
                                          AssetsUtils.appLogo,
                                        )
                                      : NetworkImage(
                                          avatarUrl,
                                        ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(
                                  60,
                                ),
                                border: Border.all(
                                  width: 2,
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Choose Photo Source"),
                                    content: const Text(
                                      "Please select the source from which the photo would uploaded",
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          try {
                                            ImagePicker picker = ImagePicker();
                                            var file = await picker.pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 50,
                                            );
                                            if (file != null) {
                                              String filename =
                                                  "${DateTime.now().toIso8601String().replaceAll(".", "").replaceAll(":", "").replaceAll(" ", "")}_${file.name}";
                                              // final Uint8List mediaFile = File(file.path!).readAsBytesSync();
                                              var uploadRes = await Supabase
                                                  .instance.client.storage
                                                  .from("ProfileImages")
                                                  .uploadBinary(
                                                    filename,
                                                    await file.readAsBytes(),
                                                  );

                                              var itemUrl = await Supabase
                                                  .instance.client.storage
                                                  .from("ProfileImages")
                                                  .getPublicUrl(
                                                    filename,
                                                  );

                                              await Supabase
                                                  .instance.client.auth
                                                  .updateUser(
                                                UserAttributes(
                                                  data: {
                                                    ...currentUserData,
                                                    "photoUrl": itemUrl,
                                                  },
                                                ),
                                              );

                                              setState(() {
                                                avatarUrl = itemUrl;
                                              });

                                              Navigator.of(context).pop();
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  e.toString(),
                                                ),
                                              ),
                                            );
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: const Text(
                                          "Gallery",
                                          style: TextStyle(
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          try {
                                            ImagePicker picker = ImagePicker();
                                            var file = await picker.pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: 50,
                                            );
                                            if (file != null) {
                                              String filename =
                                                  "${DateTime.now().toIso8601String().replaceAll(".", "").replaceAll(":", "").replaceAll(" ", "")}_${file.name}";
                                              // final Uint8List mediaFile = File(file.path!).readAsBytesSync();
                                              var uploadRes = await Supabase
                                                  .instance.client.storage
                                                  .from("ProfileImages")
                                                  .uploadBinary(
                                                    filename,
                                                    await file.readAsBytes(),
                                                  );

                                              var itemUrl = await Supabase
                                                  .instance.client.storage
                                                  .from("ProfileImages")
                                                  .getPublicUrl(
                                                    filename,
                                                  );

                                              await Supabase
                                                  .instance.client.auth
                                                  .updateUser(
                                                UserAttributes(
                                                  data: {
                                                    ...currentUserData,
                                                    "photoUrl": itemUrl,
                                                  },
                                                ),
                                              );

                                              setState(() {
                                                avatarUrl = itemUrl;
                                              });

                                              Navigator.of(context).pop();
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  e.toString(),
                                                ),
                                              ),
                                            );
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: const Text(
                                          "Camera",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.sizeOf(context).width - 60) * 0.6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ChangeEmailScreen();
                            })).then(
                              (value) {
                                getData();
                              },
                            );
                          },
                          child: const Text(
                            "Change My Email",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ChangePasswordScreen();
                            })).then(
                              (value) {
                                getData();
                              },
                            );
                          },
                          child: const Text(
                            "Change My Password",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: currentLocale,
                          items: locales.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              currentLocale = value!;
                            });

                            if (value == "English") {
                              localization.translate("en");
                            } else if (value == "العربية") {
                              localization.translate("ar");
                            }
                          },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.red,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await AuthController.logout();
                            } catch (e) {
                              print(e.toString());
                            }

                            widget.toggleNavbar(false);

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            "Log Out",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
