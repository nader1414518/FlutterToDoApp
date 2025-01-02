import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/screens/welcome_screen.dart';
import 'package:to_do_app/utils/globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final FlutterLocalization localization = FlutterLocalization.instance;

@pragma("vm:entry-point")
Future<void> onBackgroundMessageReceived(data) async {
  var notificationData = data.notification;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'todo_app_notifications',
      title: notificationData!.title,
      body: notificationData.body,
      actionType: ActionType.Default,
      // autoDismissible: true,
      criticalAlert: true,
      wakeUpScreen: true,
      category: NotificationCategory.Email,
      notificationLayout: NotificationLayout.BigText,
      payload: Map<String, String>.from(
        data.data as Map,
      ),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AdaptiveThemeMode currentTheme = AdaptiveThemeMode.light;
  try {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    currentTheme = savedThemeMode!;
  } catch (e) {
    currentTheme = AdaptiveThemeMode.light;
    print(e.toString());
  }

  if (currentTheme.isDark) {
    Globals.colorMode = "dark";
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {}

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
    FirebaseMessaging.onMessage.listen((data) {
      var notificationData = data.notification;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: notificationData!.title,
          body: notificationData.body,
          actionType: ActionType.Default,
          // autoDismissible: true,
          criticalAlert: true,
          wakeUpScreen: true,
          category: NotificationCategory.Email,
          notificationLayout: NotificationLayout.BigText,
          payload: Map<String, String>.from(
            data.data as Map,
          ),
        ),
      );
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
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

  runApp(MyApp(
    currentTheme: currentTheme,
  ));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode currentTheme;

  const MyApp({
    super.key,
    required this.currentTheme,
  });

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ar', AppLocale.AR),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MaterialApp(
          title: 'ToDo App',
          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
          theme: theme,
          darkTheme: darkTheme,
          home: WelcomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
