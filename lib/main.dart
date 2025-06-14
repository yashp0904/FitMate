import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FitMateApp());
}

class FitMateApp extends StatelessWidget {
  const FitMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
    );
  }
}
