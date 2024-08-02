import 'package:flutter/material.dart';
import 'package:flutter_video/screen/detail_screen.dart';
import 'package:flutter_video/screen/home_screen.dart';
import 'package:flutter_video/screen/video_full_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        "/home": (context) => const HomeScreen(),
        "/detail": (context) => const DetailScreen(),
      },
      // color: Color(0xff191825),
    );
  }
}
