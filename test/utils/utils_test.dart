import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/home/weather_dialog.dart';
import 'package:flutter_tdd/models/forecast.dart';
import 'package:flutter_tdd/models/temperature.dart';
import 'package:flutter_tdd/models/weather.dart';
import 'package:flutter_tdd/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late Location location;
  late _ArrangeBuilder builder;
  late BuildContext context;
  late WeatherRegister register;
  late DialogController dialogController;

  setUpAll(() {
    registerFallbackValue(FakeDioResponse());
    registerFallbackValue(FakeUri());
  });

  setUp(
    () {
      dio = MockDio();
      location = MockLocation();
      context = MockBuildContext();
      dialogController = MockDialogController();
      register = WeatherRegister(
        location: location,
        dio: dio,
        dialogController: dialogController,
      );
      builder = _ArrangeBuilder(dio, location, dialogController);
    },
  );

  test(
    'get location',
    () async {
      final currentLocation = LocationData.fromMap({
        'latitude': 1.2,
        'longitude': 3.4,
      });
      builder
        ..withServiceEnabled()
        ..withPermission()
        ..withLocation(currentLocation);

      final _location = await register.getLocation();

      expect(_location, currentLocation);
    },
  );

  test(
    'get weather by location',
    () async {
      final currentLocation = LocationData.fromMap({
        'latitude': 1.2,
        'longitude': 3.4,
      });
      builder
        ..withServiceEnabled()
        ..withPermission()
        ..withLocation(currentLocation)
        ..withForecast(
          {
            'weather': [
              {
                'main': "Clouds",
                'description': "A lot of clouds",
              }
            ],
            'main': {
              'temp': 12.1,
            },
          },
        );

      final weather = await register.getWeather(currentLocation);

      expect(
        weather,
        Forecast(
          main: Temperature(temp: 12.1),
          weather: [
            Weather(
              main: 'Clouds',
              description: 'A lot of clouds',
            )
          ],
        ),
      );
    },
  );

  test('show dialog', () async {
    final testForecast = Forecast(
      main: Temperature(temp: 12.1),
      weather: [
        Weather(
          main: 'Clouds',
          description: 'A lot of clouds',
        )
      ],
    );
    final currentLocation = LocationData.fromMap({
      'latitude': 1.2,
      'longitude': 3.4,
    });
    builder
      ..withServiceEnabled()
      ..withPermission()
      ..withLocation(currentLocation)
      ..withShowDialog(context, testForecast)
      ..withForecast(
        {
          'weather': [
            {
              'main': "Clouds",
              'description': "A lot of clouds",
            }
          ],
          'main': {
            'temp': 12.1,
          },
        },
      );

    await register.showWeatherToday(context);

    verify(
      () => dialogController.show(
        context,
        testForecast,
      ),
    );
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(this.dio, this.location, this.dialogController);

  final Dio dio;
  final Location location;
  final DialogController dialogController;

  void withServiceEnabled() {
    when(() => location.serviceEnabled()).thenAnswer((_) => Future.value(true));
  }

  void withPermission() {
    when(() => location.hasPermission())
        .thenAnswer((_) => Future.value(PermissionStatus.granted));
  }

  void withLocation(LocationData currentLocation) {
    when(() => location.getLocation())
        .thenAnswer((_) => Future.value(currentLocation));
  }

  void withForecast(
    final Map<String, dynamic> data, {
    final String? url,
  }) {
    when(
      () => dio.getUri<dynamic>(any()),
    ).thenAnswer(
      (final _) async => Response<dynamic>(
        requestOptions: RequestOptions(path: 'any'),
        data: data,
        extra: {},
        statusCode: 200,
      ),
    );
  }

  void withShowDialog(
    final BuildContext context,
    final Forecast forecast,
  ) {
    when(() => dialogController.show(context, forecast))
        .thenAnswer((invocation) {
      return Future.value();
    });
  }
}

class MockDio extends Mock implements Dio {}

class MockLocation extends Mock implements Location {}

class MockBuildContext extends Mock implements BuildContext {}

class MockDialogController extends Mock implements DialogController {}

class FakeDioResponse extends Fake implements Response<dynamic> {}

class FakeUri extends Fake implements Uri {}
