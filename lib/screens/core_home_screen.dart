import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:to_do_app/locale/app_locale.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/screens/calendar_screen.dart';
import 'package:to_do_app/screens/favorites_screen.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/profile_screen.dart';
import 'package:to_do_app/screens/teams_screen.dart';
import 'package:to_do_app/utils/globals.dart';

class CoreHomeScreen extends StatefulWidget {
  @override
  CoreHomeScreenState createState() => CoreHomeScreenState();
}

class CoreHomeScreenState extends State<CoreHomeScreen> {
  bool isShown = true;

  toggleNavbar(bool value) {
    setState(() {
      isShown = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isShown = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: localization.currentLocale!.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: PersistentTabView(
          context,
          screens: [
            HomeScreen(),
            TeamsScreen(
              toggleNavbar: toggleNavbar,
            ),
            CalendarScreen(),
            FavoritesScreen(),
            ProfileScreen(
              toggleNavbar: toggleNavbar,
            ),
          ],
          items: [
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.home),
              title: AppLocale.home_screen_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.person_2_square_stack),
              title: AppLocale.teams_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.calendar),
              title: AppLocale.calendar_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.square_favorites_alt),
              title: AppLocale.favorites_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.person),
              title: AppLocale.profile_label.getString(
                context,
              ),
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
          ],
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
          stateManagement: false, // Default is true.
          hideNavigationBarWhenKeyboardAppears: true,
          // popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          backgroundColor: Globals.colorMode == "dark"
              ? Colors.grey.shade900
              : Colors.white60,
          isVisible: isShown,
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              duration: Duration(milliseconds: 200),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
            ),
          ),
          confineToSafeArea: true,
          navBarHeight: kBottomNavigationBarHeight * 1.1,
          navBarStyle:
              NavBarStyle.style8, // Choose the nav bar style with this property
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(
              30,
            ),
            colorBehindNavBar: Colors.transparent,
          ),
          margin: EdgeInsets.only(
            bottom: isShown ? 10 : 0,
            left: 10,
            right: 10,
          ),
        ),
      ),
    );
  }
}
