import 'package:flutter/material.dart';
import 'ui/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CarnetAlumnoApp());
}

class CarnetAlumnoApp extends StatelessWidget {
  const CarnetAlumnoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet Estudiantil UAGro',
      theme: AppTheme.light,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
