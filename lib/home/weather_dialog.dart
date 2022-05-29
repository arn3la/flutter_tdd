import 'package:flutter/material.dart';
import 'package:flutter_tdd/models/forecast.dart';

class DialogController {
  Future<void> show(
    final BuildContext context,
    final Forecast forecast,
  ) async =>
      _showWeatherDialog(context, forecast);

  void _showWeatherDialog(
    BuildContext context,
    Forecast forecast,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(24, 21, 24, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          title: Text(
            forecast.weather.first.main,
            style: TextStyle(color: Colors.red),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(forecast.weather.first.description),
              Text('temp: ${forecast.main.temp}° C'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
