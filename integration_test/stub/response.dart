class LocalResponse {
  LocalResponse(
    this.body, {
    this.statusCode,
    this.headers,
  });

  factory LocalResponse.success(
    final dynamic body, {
    final Map<String, String>? headers,
  }) =>
      LocalResponse(body, statusCode: 200, headers: headers);

  final Object body;
  final int? statusCode;
  final Map<String, String>? headers;
}
