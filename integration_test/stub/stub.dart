import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'request.dart';
import 'response.dart';

abstract class StubResponder {
  Future<LocalResponse> respond(final Request request);
}

class StubHttpClientAdapter extends HttpClientAdapter {
  StubHttpClientAdapter(this.responder);

  final StubResponder responder;

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<dynamic>? cancelFuture,
  ) async {
    final request = Request(
      uri: options.uri,
      method: options.method,
      headers: options.headers,
    );

    final response = await responder.respond(request);

    if (response.body is String) {
      return ResponseBody.fromString(
        response.body.toString(),
        response.statusCode,
        headers: (response.headers ?? <String, String>{}).map(
          (final key, final value) => MapEntry(key, [value]),
        ),
      );
    }

    throw Exception('Response is not parsable');
  }

  @override
  void close({final bool force = false}) {}
}

class StubResponderImpl implements StubResponder {
  const StubResponderImpl();

  @override
  Future<LocalResponse> respond(final Request request) async {
    if (request.uri.host == 'api.openweathermap.org' &&
        request.uri.path == '/data/2.5/weather') {
      return LocalResponse.success(
        '''
        {
          "weather": [
            {
              "main": "Clouds",
              "description": "few clouds"
            }
          ],
          "main": {
            "temp": 13.36
          }
        }
        ''',
        headers: {'content-type': 'application/hal+json;charset=UTF-8'},
      );
    }

    return LocalResponse(
      '{"error": "Not found ${request.uri}"}',
      statusCode: 404,
      headers: {'content-type': 'application/hal+json;charset=UTF-8'},
    );
  }
}
