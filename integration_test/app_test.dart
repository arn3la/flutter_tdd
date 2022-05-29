import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'stub/stub.dart';

void main() => _testMain();

void _testMain() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Dio dio;
  late MyApp app;

  Future<void> initializeApp() async {
    dio = Dio()..httpClientAdapter = StubHttpClientAdapter(StubResponderImpl());

    final moduleHandler =
        ModuleHandler.initialize(location: location, dio: dio);

    app = MyApp(moduleHandler: moduleHandler);
  }

  setUp(() async {
    await initializeApp();
  });

  testWidgets('integration test', (WidgetTester tester) async {
    runApp(app);
    await tester.pumpAndSettle();

    expect(find.text('Hello World!'), findsOneWidget);
    expect(find.text('Weather today'), findsOneWidget);
    expect(find.byKey(Key('icon_weather')), findsOneWidget);

    await tester.tap(find.text('Weather today'));
    await tester.pumpAndSettle(Duration(seconds: 3));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Clouds'), findsOneWidget);
    expect(find.text('few clouds'), findsOneWidget);
    expect(find.text('temp: 13.36° C'), findsOneWidget);
  });
}
