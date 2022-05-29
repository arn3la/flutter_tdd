import 'package:dio/dio.dart';
import 'package:flutter_tdd/models/forecast.dart';

// TODO: Add api key
const String _apiKey = '';
const String _hostName = 'https://api.openweathermap.org/data/2.5/weather';

class Api {
  const Api(this.dio);

  final Dio dio;

  Future<Forecast> getWeather({
    required String lat,
    required String lon,
  }) async {
    final response = await dio.getUri<dynamic>(
      Uri.parse('$_hostName?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
    );

    return Forecast.fromJson(response.data);
  }
}
