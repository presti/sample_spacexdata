import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';
import 'package:sample_spacexdata/utils/equality.dart';

class Launch extends Equality {
  final Rocket rocket;
  final bool? isSuccess;
  final DateTime dateTime;

  const Launch({
    required this.rocket,
    required this.isSuccess,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [rocket, isSuccess, dateTime];
}
