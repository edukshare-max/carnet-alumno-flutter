import 'package:flutter/material.dart';
import 'ui/app_theme.dart';
import 'ui/brand.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(CarnetAlumnoApp());
}

class CarnetAlumnoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAGro Carnet Alumno',
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
    );
  }
}
