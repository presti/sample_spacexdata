import 'package:meta/meta.dart';

import '../equality.dart';
import '../logger.dart';

const Success<void, Failure> successVoid = Success(null);

abstract class May<V, F extends Failure> {
  static May<V, F> of<V, F extends Failure>(
      V Function() mayThrow, F Function(Object error, StackTrace) failure) {
    try {
      return Success(mayThrow());
    } catch (e, s) {
      return Fail(failure(e, s));
    }
  }

  T on<T>({
    required T Function(V) onSuccess,
    required T Function(F) onFailure,
  });

  May<V2, F> onSuccess<V2>(May<V2, F> Function(V) onSuccess);

  Future<May<V2, F>> onSuccessFuture<V2>(
      Future<May<V2, F>> Function(V) onSuccess);

  May<V, F2> onFailure<F2 extends Failure>(May<V, F2> Function(F) onFailure);

  Future<May<V, F2>> onFailureFuture<F2 extends Failure>(
      Future<May<V, F2>> Function(F) onFailure);

  May<V2, F2> cast<V2, F2 extends Failure>();

  V force() {
    return Logger.i.tryError(() {
      return on(
        onSuccess: (v) => v,
        onFailure: (f) => throw f,
      );
    });
  }
}

@immutable
class Success<V, F extends Failure> with May<V, F> {
  final V _value;

  const Success(this._value);

  @override
  T on<T>({
    required T Function(V) onSuccess,
    required T Function(Never) onFailure,
  }) =>
      onSuccess(_value);

  @override
  May<V2, F> onSuccess<V2>(May<V2, F> Function(V) onSuccess) {
    return onSuccess(_value);
  }

  @override
  Future<May<V2, F>> onSuccessFuture<V2>(
      Future<May<V2, F>> Function(V) onSuccess) {
    return onSuccess(_value);
  }

  @override
  May<V, F2> onFailure<F2 extends Failure>(May<V, F2> Function(F) onFailure) {
    return Success(_value);
  }

  @override
  Future<May<V, F2>> onFailureFuture<F2 extends Failure>(
      Future<May<V, F2>> Function(F) onFailure) async {
    return Success(_value);
  }

  @override
  May<V2, F2> cast<V2, F2 extends Failure>() {
    assert(this is May<V2, F2>);
    return Success(_value as V2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<V, F> && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Success($_value)';
}

@immutable
class Fail<V, F extends Failure> with May<V, F> {
  final F _failure;

  Fail(this._failure) {
    Logger.i.log(_failure);
  }

  Fail._create(this._failure);

  @override
  T on<T>({
    required T Function(Never) onSuccess,
    required T Function(F) onFailure,
  }) =>
      onFailure(_failure);

  @override
  May<V2, F> onSuccess<V2>(May<V2, F> Function(V) onSuccess) {
    return Fail._create(_failure);
  }

  @override
  Future<May<V2, F>> onSuccessFuture<V2>(
      Future<May<V2, F>> Function(V) onSuccess) async {
    return Fail._create(_failure);
  }

  @override
  May<V, F2> onFailure<F2 extends Failure>(May<V, F2> Function(F) onFailure) {
    return onFailure(_failure);
  }

  @override
  Future<May<V, F2>> onFailureFuture<F2 extends Failure>(
      Future<May<V, F2>> Function(F) onFailure) async {
    return onFailure(_failure);
  }

  @override
  May<V2, F2> cast<V2, F2 extends Failure>() {
    assert(this is May<V2, F2>);
    return Fail._create(_failure as F2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fail<V, F> && _failure == other._failure;

  @override
  int get hashCode => _failure.hashCode;

  @override
  String toString() => 'Fail($_failure)';
}

class Failure extends Equality {
  Object? get data => null;

  const Failure();

  Fail<V, Failure> wrap<V>() {
    return Fail._create(this);
  }

  @override
  String toString() {
    //ignore: no_runtimeType_toString
    return '$runtimeType-${data ?? ''}';
  }

  @override
  List<Object?> get props => [data];
}

extension OnSuccessWithFuture<V, F extends Failure> on Future<May<V, F>> {
  Future<T> on<T>({
    required Future<T> Function(V) onSuccess,
    required Future<T> Function(F) onFailure,
  }) async {
    May<V, F> may = await this;
    return may.on(onSuccess: onSuccess, onFailure: onFailure);
  }

  Future<May<V2, F>> onSuccess<V2>(
      Future<May<V2, F>> Function(V) onSuccess) async {
    May<V, F> may = await this;
    return may.onSuccessFuture(onSuccess);
  }

  Future<May<V, F2>> onFailure<F2 extends Failure>(
      Future<May<V, F2>> Function(F) onFailure) async {
    May<V, F> may = await this;
    return may.onFailureFuture(onFailure);
  }

  Future<May<V2, F2>> cast<V2, F2 extends Failure>() async {
    May<V, F> may = await this;
    return may.cast();
  }
}

extension ListMay<T> on List<T> {
  May<List<V>, F> mapMay<V, F extends Failure>(May<V, F> Function(T) f) {
    List<V> list = [];
    Fail<List<V>, F>? fail;
    for (final e in this) {
      f(e).on(
        onSuccess: (v) => list.add(v),
        onFailure: (f) => fail = Fail(f),
      );
      if (fail != null) {
        break;
      }
    }
    return fail ?? Success(list);
  }
}
