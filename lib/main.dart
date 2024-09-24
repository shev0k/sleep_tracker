import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,  // screen orientation to portrait mode
  ]).then((_) {
    runApp(SleepApp());
  });
}

class SleepApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  SleepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Tracker App',
      debugShowCheckedModeBanner: false, // disable debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: const HomeScreen(),
    );
  }
}
