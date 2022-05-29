import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/home/home_page.dart';
import 'package:location/location.dart';

void main() {
  runApp(
    MyApp(
      moduleHandler: ModuleHandler.initialize(
        location: location,
        dio: dio,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.moduleHandler,
  }) : super(key: key);

  final ModuleHandler moduleHandler;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InjectorWidget(
        moduleHandler: moduleHandler,
        child: HomePage(),
      ),
    );
  }
}

final location = Location();
final dio = Dio();

class ModuleHandler {
  ModuleHandler._(this.location, this.dio);

  factory ModuleHandler.initialize({
    required Location location,
    required Dio dio,
  }) =>
      _instance ??= ModuleHandler._(location, dio);

  static ModuleHandler? _instance;

  late final Location location;
  late final Dio dio;
}

@immutable
class InjectorWidget extends InheritedWidget {
  const InjectorWidget({
    required Widget child,
    required this.moduleHandler,
  }) : super(child: child);

  static ModuleHandler of(final BuildContext context) {
    final injector =
        context.dependOnInheritedWidgetOfExactType<InjectorWidget>();

    if (injector != null) {
      return injector.moduleHandler;
    }

    throw Exception();
  }

  final ModuleHandler moduleHandler;

  @override
  bool updateShouldNotify(final InjectorWidget oldWidget) => false;
}
