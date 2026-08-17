import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ViskeyApp());
}

class ViskeyApp extends StatelessWidget {
  const ViskeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VISKEY',
      theme: AppTheme.dark,
      home: const Scaffold(
        body: Center(
          child: Text(
            'VISKEY',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
