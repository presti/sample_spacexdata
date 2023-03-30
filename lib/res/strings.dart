import 'package:flutter/widgets.dart';

extension BuildContextSrings on BuildContext {
  // The context is not needed, but it is used for a seamless
  // transition to internationalization.
  Strings get s => Strings.i;
}

class Strings {
  static const Strings i = Strings._();

  const Strings._();

  String get appTitle => 'SpaceX Sample';

  String get homeTitle => 'Rockets';

  String get error => 'Something wrong happened';

  String launchesTitle(String rocketName) => '$rocketName launches';

  String get launchesEmpty => 'No launches to show';
}
