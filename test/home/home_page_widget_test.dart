import 'package:flutter/material.dart';
import 'package:flutter_tdd/home/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home page is created', (WidgetTester tester) async {
    final testWidget = MaterialApp(
      home: HomePage(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('home page contains hello world text',
      (WidgetTester tester) async {
    final testWidget = MaterialApp(
      home: HomePage(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('Hello World!'), findsOneWidget);
  });

  testWidgets('home page contains button', (WidgetTester tester) async {
    final testWidget = MaterialApp(
      home: HomePage(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    final buttonMaterial = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.byType(Material),
    );

    final materialButton = tester.widget<Material>(buttonMaterial);

    expect(materialButton.color, Colors.blue);
    expect(find.text('Weather today'), findsOneWidget);
    expect(find.byKey(Key('icon_weather')), findsOneWidget);
  });
}
