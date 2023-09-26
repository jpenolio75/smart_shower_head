import 'package:flutter/material.dart';
import 'package:smart_shower_head/widgets/settings_page.dart';
import 'package:smart_shower_head/widgets/homescreen_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase_notif.dart';

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const SmartShowerHead());
}

class SmartShowerHead extends StatelessWidget {
  const SmartShowerHead({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Shower Head',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SmartShowerHeadPage(title: 'Smart Shower Head'),
    );
  }
}

class SmartShowerHeadPage extends StatefulWidget {
  const SmartShowerHeadPage({super.key, required this.title});
  final String title;

  @override
  State<SmartShowerHeadPage> createState() => _SmartShowerHeadPageState();
}

class _SmartShowerHeadPageState extends State<SmartShowerHeadPage> {
  _SmartShowerHeadPageState();

  //This function handles calling the command voice functions

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar()
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List<Widget> buildScreens() {
      return [
        const HomeScreenPage(),
        const SettingsPage(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems(){
      return [

        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: Colors.white,
        ), 

        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: Colors.white,
        )

      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      screens:buildScreens(),
      items: navBarsItems(),
      controller: controller,
      confineInSafeArea: true,
      backgroundColor: Colors.blue,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
      NavBarStyle.style6,


    );
  }
}