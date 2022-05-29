import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/api/api.dart';
import 'package:flutter_tdd/home/weather_dialog.dart';
import 'package:flutter_tdd/models/forecast.dart';
import 'package:location/location.dart';

class WeatherRegister {
  const WeatherRegister({
    required this.location,
    required this.dio,
    required this.dialogController,
  });

  final Location location;
  final Dio dio;
  final DialogController dialogController;

  Future<void> showWeatherToday(BuildContext context) async {
    final currentLocation = await getLocation();
    final forecast = await getWeather(currentLocation);

    dialogController.show(context, forecast);
  }

  Future<Forecast> getWeather(LocationData locationData) {
    return Api(dio).getWeather(
      lat: locationData.latitude.toString(),
      lon: locationData.longitude.toString(),
    );
  }

  Future<LocationData> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Exception('Service is not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Permission is not granted');
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }
}
