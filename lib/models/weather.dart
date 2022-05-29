import 'package:flutter/material.dart';

@immutable
class Weather {
  const Weather({
    required this.main,
    required this.description,
  });

  final String main;
  final String description;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        main: json['main'],
        description: json['description'],
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Weather &&
          runtimeType == other.runtimeType &&
          main == other.main &&
          description == other.description;

  @override
  int get hashCode => main.hashCode ^ description.hashCode;
}
