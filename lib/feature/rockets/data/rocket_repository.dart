import 'package:sample_spacexdata/feature/launches/data/launch.dart';
import 'package:sample_spacexdata/feature/launches/data/launch_dto.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket_dto.dart';
import 'package:sample_spacexdata/providers/http_provider.dart';
import 'package:sample_spacexdata/utils/functional/may.dart';

class RocketRepository {
  const RocketRepository._();

  static const RocketRepository i = RocketRepository._();

  static const _baseUrl = 'https://api.spacexdata.com/v3/';
  static const _rocketsUrl =
      '${_baseUrl}rockets?filter=rocket_id,rocket_name,flickr_images';

  static String _launchesUrl(String rocketId) =>
      '${_baseUrl}launches?rocket_id=$rocketId&filter=launch_success,launch_date_unix';

  Future<May<List<Rocket>, Failure>> getRockets() async {
    return HttpProvider.i.getAndDecodeList(
      url: _rocketsUrl,
      fromJson: (jsonList) {
        return jsonList
            .map((json) => RocketDto.fromJson(json).toModel())
            .toList();
      },
    );
  }

  Future<May<List<Launch>, Failure>> getLaunches(Rocket rocket) async {
    return HttpProvider.i.getAndDecodeList(
      url: _launchesUrl(rocket.id),
      fromJson: (jsonList) {
        return jsonList
            .map((json) => LaunchDto.fromJson(json).toModel(rocket))
            .toList();
      },
    );
  }
}
