import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Import HomePage
import 'theme/app_theme.dart'; // Import AppTheme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlarmCat',
      theme: AppTheme.lightTheme, // Use the custom light theme
      darkTheme: AppTheme.darkTheme, // Use the custom dark theme
      themeMode: ThemeMode.system, // Optionally allow system theme preference
      home: const HomePage(),
    );
  }
}