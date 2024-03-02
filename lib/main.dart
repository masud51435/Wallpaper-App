import 'package:flutter/material.dart';
import 'package:wallpaper/homepage.dart';

void main() {
  //timeDilation = 3.0;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WallPaper appp',
      theme: ThemeData.light(),
      home: const HomePage(),
    );
  }
}
