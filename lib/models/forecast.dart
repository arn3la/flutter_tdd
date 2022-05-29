import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/models/temperature.dart';
import 'package:flutter_tdd/models/weather.dart';

@immutable
class Forecast {
  const Forecast({
    required this.main,
    required this.weather,
  });

  final Temperature main;
  final List<Weather> weather;

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        main: Temperature.fromJson(json['main']),
        weather: (json['weather'] as List<dynamic>)
            .map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Forecast &&
          runtimeType == other.runtimeType &&
          main == other.main &&
          const ListEquality<Weather>().equals(weather, other.weather);

  @override
  int get hashCode =>
      main.hashCode ^ const ListEquality<Weather>().hash(weather);
}
