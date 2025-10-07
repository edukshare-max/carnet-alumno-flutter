// This is a basic Flutter widget test for UAGro Carnet Alumno app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:carnet_alumno/main.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CarnetAlumnoApp());

    // Verify that we have the login screen elements
    expect(find.text('UAGro'), findsOneWidget);
    expect(find.text('Carnet Estudiantil UAGro'), findsOneWidget);
    expect(find.text('Correo Electrónico'), findsOneWidget);
    expect(find.text('Matrícula'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
