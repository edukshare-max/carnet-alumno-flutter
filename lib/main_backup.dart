import 'package:flutter/material.dart';

void main() {
  runApp(const MinimalTestApp());
}

class MinimalTestApp extends StatelessWidget {
  const MinimalTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Minimal',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🚀 FLUTTER FUNCIONANDO v3.0'),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡ÉXITO! Flutter Web funciona',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Carnet Digital UAGro v3.0 FINAL'),
              SizedBox(height: 20),
              Icon(Icons.check_circle, color: Colors.green, size: 64),
            ],
          ),
        ),
      ),
    );
  }
}