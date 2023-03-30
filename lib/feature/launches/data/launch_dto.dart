import 'package:sample_spacexdata/feature/launches/data/launch.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';
import 'package:sample_spacexdata/utils/equality.dart';
import 'package:sample_spacexdata/utils/json_utils.dart';

//ignore_for_file: non_constant_identifier_names
class LaunchDto extends Equality {
  final bool? launch_success;
  final int launch_date_unix;

  const LaunchDto._({
    required this.launch_success,
    required this.launch_date_unix,
  });

  static LaunchDto fromJson(Json json) {
    return LaunchDto._(
      launch_success: json['launch_success'] as bool?,
      launch_date_unix: json['launch_date_unix'] as int,
    );
  }

  Launch toModel(Rocket rocket) {
    return Launch(
      rocket: rocket,
      isSuccess: launch_success,
      dateTime: DateTime.fromMillisecondsSinceEpoch(launch_date_unix * 1000),
    );
  }

  @override
  List<Object?> get props => [launch_success, launch_date_unix];
}
