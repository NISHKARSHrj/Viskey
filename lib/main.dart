import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/home/home_screens.dart';
void main() {
  runApp(const ViskeyApp());
}

class ViskeyApp extends StatelessWidget {
  const ViskeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hellp',
      theme: AppTheme.dark,
      home: const HomeScreens(),
    );
  }
}
