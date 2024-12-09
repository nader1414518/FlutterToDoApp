import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    var status =
        await AwesomeNotifications().requestPermissionToSendNotifications();

    if (status) {
      var isInitialized = await AwesomeNotifications().initialize(
        null,
        // set the icon to null if you want to use the default app icon
        // 'resource://drawable/res_app_icon',
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
          ),
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group',
          ),
        ],
        // debug: true,
      );
    }
  } catch (e) {
    print(e.toString());
  }

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e.toString());
  }

  try {
    await Supabase.initialize(
      url: dotenv.env["SUPABSE_PROJECT_URL"].toString(),
      anonKey: dotenv.env["SUPABSE_API_KEY"].toString(),
    );
  } catch (e) {
    print(e.toString());
  }

  await initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
