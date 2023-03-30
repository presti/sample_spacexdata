import 'dart:developer' as dev;

class Logger {
  static final Logger i = Logger._();

  bool enabled = true;

  Logger._();

  void log(Object object) {
    String msg = 'AQL:$object';
    if (enabled) {
      dev.log(msg);
    }
  }

  T tryError<T>(T Function() f) {
    try {
      return f();
    } catch (e) {
      log(e);
      rethrow;
    }
  }
}
