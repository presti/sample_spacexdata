import 'package:flutter/widgets.dart';
import 'package:get/get.dart' as getx;

@immutable
class Data<T> {
  final getx.Rx<T> _rx;
  final T Function(T value)? _interceptor;

  Data(
    T value, {
    T Function(T value)? interceptor,
  })  : _rx = getx.Rx(value),
        _interceptor = interceptor;

  T get value => _rx.value;

  set value(T val) {
    _rx.value = _interceptor == null ? val : _interceptor!(val);
  }

  DataBuilder builder(Widget Function(T) f) => DataBuilder._(() => f(value));

  Disposable onChange(void Function(T) callback) {
    final worker = getx.ever(_rx, callback);
    return Disposable._(worker);
  }

  @override
  String toString() {
    return 'Data($value)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Data<T> &&
          runtimeType == other.runtimeType &&
          _rx == other._rx &&
          _interceptor == other._interceptor;

  @override
  int get hashCode => Object.hash(_rx, _interceptor);
}

class DataBuilder extends getx.Obx {
  const DataBuilder._(Widget Function() builder) : super(builder);
}

class Disposable {
  final getx.Worker worker;

  Disposable._(this.worker);

  void dispose() => worker.dispose();
}
