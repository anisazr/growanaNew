import 'package:flutter/material.dart';
import 'package:growana/screens/login_page.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growana Shopping List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1D7140),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D7140),
          primary: const Color(0xFF1D7140),
        ),
      ),
      home: const HomePage(),
      routes: {'/login': (context) => const LoginPage()},
    );
  }
}
