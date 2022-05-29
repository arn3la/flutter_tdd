class Request {
  Request({
    required this.uri,
    required this.method,
    this.headers,
  });

  final Uri uri;
  final String method;
  final Map<String, dynamic>? headers;
}
