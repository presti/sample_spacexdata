import '../external/http_service.dart';
import '../external/service_locator.dart';
import '../utils/functional/may.dart';
import '../utils/json_utils.dart';

class HttpProvider {
  static const HttpProvider i = HttpProvider._();

  HttpService get _httpService => sl().httpService;

  const HttpProvider._();

  Future<May<HttpResponse, Failure>> get({required String url}) {
    return _call(() => _httpService.get(url));
  }

  Future<May<T, Failure>> getAndDecodeList<T>({
    required String url,
    required T Function(List<Json> jsonList) fromJson,
  }) {
    return _getAndDecodeJson(
      url: url,
      fromJson: (List<dynamic> jsonList) =>
          fromJson(jsonList.cast<Map<String, dynamic>>()),
    );
  }

  Future<May<T, Failure>> _getAndDecodeJson<T, J>({
    required String url,
    required T Function(J json) fromJson,
  }) {
    return get(url: url)
        .cast<HttpResponse, Failure>()
        .onSuccess((res) async => JsonUtils.i.decode<J>(res.body))
        .onSuccess((json) async => JsonUtils.i.fromJson(json, fromJson));
  }

  Future<May<HttpResponse, Failure>> _call(
      Future<May<HttpResponse, HttpErrorFailure>> Function() call) async {
    return call()
        .cast<HttpResponse, Failure>()
        .onSuccess<HttpResponse>((response) async {
      int statusCode = response.statusCode;
      if (statusCode >= 100 && statusCode < 300) {
        return Success(HttpResponse(
          statusCode: statusCode,
          body: response.body,
        ));
      } else {
        return Fail(HttpNotSuccessfulFailure(statusCode: statusCode));
      }
    });
  }
}

class HttpNotSuccessfulFailure extends Failure {
  final int statusCode;

  const HttpNotSuccessfulFailure({required this.statusCode});

  @override
  List<Object?> get props => [...super.props, statusCode];
}
