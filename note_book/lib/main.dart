import 'package:flutter/material.dart';
import 'package:note_book/screen/splash_screen.dart';
import 'package:note_book/services/shared_preferance.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferenceServices.oninit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
