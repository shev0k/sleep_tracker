import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home/home_screen.dart';
import 'screens/introduction/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App runs only in portrait mode.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Retrieve shared preferences instance and check introduction screen status.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenIntroduction = prefs.getBool('hasSeenIntroduction') ?? false;

  runApp(SleepApp(hasSeenIntroduction: hasSeenIntroduction));
}

class SleepApp extends StatelessWidget {
  final bool hasSeenIntroduction;

  const SleepApp({super.key, required this.hasSeenIntroduction});

  @override
  Widget build(BuildContext context) {
    // Setting up system UI overlay styles.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'Sleep Tracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: hasSeenIntroduction
          ? const HomeScreen()
          : const IntroductionAnimationScreen(),
    );
  }
}
