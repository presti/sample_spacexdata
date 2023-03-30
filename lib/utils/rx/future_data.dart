import 'package:flutter/widgets.dart';

import '../functional/may.dart';
import 'data.dart';

class FutureData<T, F extends Failure> {
  final Future<May<T, F>?> Function() _loader;
  final Data<bool> isLoadingData = Data(false);
  May<T, F>? _mayValue;

  FutureData(this._loader);

  DataBuilder builder(Widget Function(May<T, F>? value, bool isLoading) f) {
    return isLoadingData.builder((isLoading) => f(_mayValue, isLoading));
  }

  /// You would normally not want to await this.
  Future<void> load() async {
    isLoadingData.value = true;
    _mayValue = await _loader();
    isLoadingData.value = false;
  }
}
