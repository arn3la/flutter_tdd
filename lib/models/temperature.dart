import 'package:flutter/material.dart';

@immutable
class Temperature {
  const Temperature({required this.temp});

  final double temp;

  factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
        temp: json['temp'].toDouble(),
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Temperature &&
          runtimeType == other.runtimeType &&
          temp == other.temp;

  @override
  int get hashCode => temp.hashCode;
}
