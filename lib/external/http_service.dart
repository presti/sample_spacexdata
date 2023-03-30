import 'package:http/http.dart' as http;

import '../utils/equality.dart';
import '../utils/functional/may.dart';

class HttpService {
  static const HttpService i = HttpService._();

  const HttpService._();

  Future<May<HttpResponse, HttpErrorFailure>> get(
    String url, {
    Map<String, String>? headers,
  }) {
    return _request(() => http.get(Uri.parse(url), headers: headers));
  }

  Future<May<HttpResponse, HttpErrorFailure>> post(
    String url, {
    Map<String, String>? headers,
    String? body,
  }) {
    return _request(
        () => http.post(Uri.parse(url), body: body, headers: headers));
  }

  Future<May<HttpResponse, HttpErrorFailure>> _request(
      Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request();
    } catch (e) {
      return Fail(HttpErrorFailure(e));
    }
    return Success(HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    ));
  }
}

class HttpResponse extends Equality {
  final int statusCode;
  final String body;

  const HttpResponse({
    required this.statusCode,
    required this.body,
  });

  @override
  List<Object> get props => [statusCode, body];
}

class HttpErrorFailure extends Failure {
  final Object error;

  const HttpErrorFailure(this.error);

  @override
  List<Object?> get props => [...super.props, error];
}
