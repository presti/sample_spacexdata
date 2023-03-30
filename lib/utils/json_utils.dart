import 'dart:convert' as convert;

import 'functional/may.dart';

typedef Json = Map<String, dynamic>;

class JsonUtils {
  static const JsonUtils i = JsonUtils._();

  const JsonUtils._();

  Json from(Map map) {
    return Map.castFrom<dynamic, dynamic, String, dynamic>(map);
  }

  May<T, Failure> fromJson<T, J>(J json, T Function(J) fromJson) {
    T t;
    try {
      t = fromJson(json);
    } catch (e) {
      return Fail(JsonInvalidFailure(e, json));
    }
    return Success(t);
  }

  May<J, Failure> decode<J>(String text) {
    J json;
    try {
      json = convert.json.decode(text) as J;
    } catch (e) {
      return Fail(JsonDecodingFailure(e, text));
    }
    return Success(json);
  }
}

class JsonInvalidFailure<J> extends Failure {
  final Object error;
  final J json;

  @override
  Object? get data => '$error : $json';

  const JsonInvalidFailure(this.error, this.json);

  @override
  List<Object?> get props => [...super.props, error, json];
}

class JsonDecodingFailure extends Failure {
  final Object error;
  final String src;

  @override
  Object? get data => '$error : $src';

  const JsonDecodingFailure(this.error, this.src);

  @override
  List<Object?> get props => [...super.props, error, src];
}
