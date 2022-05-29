import 'package:dio/dio.dart';
import 'package:flutter_tdd/api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late Api api;
  late Dio dio;
  late _ArrangeBuilder builder;

  setUpAll(() {
    registerFallbackValue(FakeDioResponse());
    registerFallbackValue(FakeUri());
  });

  setUp(
    () {
      dio = MockDio();
      api = Api(dio);

      builder = _ArrangeBuilder(dio);
    },
  );

  test(
    'sends get request to valid endpoint',
    () async {
      builder.withSuccessfulGetResponse(
        {
          'weather': [
            {
              'main': "Clouds",
              'description': "few clouds",
              'icon': "02d",
            }
          ],
          'main': {
            'temp': 13.36,
          },
        },
      );

      await api.getWeather(
        lat: '1',
        lon: '2',
      );

      // TODO: Add app key
      verify(
        () => dio.getUri<dynamic>(
          Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=1'
            '&lon=2&appid=APPID&units=metric',
          ),
        ),
      );
    },
  );
}

class _ArrangeBuilder {
  _ArrangeBuilder(this.dio);

  final Dio dio;

  void withSuccessfulGetResponse(
    final Map<String, dynamic> data, {
    final String? url,
  }) {
    when(
      () => dio.getUri<dynamic>(
        url != null ? Uri.parse(url) : any(),
      ),
    ).thenAnswer(
      (final _) async => Response<dynamic>(
        requestOptions: RequestOptions(path: 'any'),
        data: data,
        extra: {},
        statusCode: 200,
      ),
    );
  }
}

class MockDio extends Mock implements Dio {}

class FakeDioResponse extends Fake implements Response<dynamic> {}

class FakeUri extends Fake implements Uri {}
