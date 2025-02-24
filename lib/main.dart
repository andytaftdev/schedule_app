import 'package:flutter/material.dart';
import 'package:schedule_app/ui/home_screen.dart';
//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
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
