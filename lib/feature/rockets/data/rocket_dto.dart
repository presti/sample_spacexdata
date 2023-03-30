import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';
import 'package:sample_spacexdata/utils/equality.dart';
import 'package:sample_spacexdata/utils/json_utils.dart';

//ignore_for_file: non_constant_identifier_names
class RocketDto extends Equality {
  final String rocket_id;
  final String rocket_name;
  final List<String> flickr_images;

  const RocketDto._({
    required this.rocket_id,
    required this.rocket_name,
    required this.flickr_images,
  });

  static RocketDto fromJson(Json json) {
    return RocketDto._(
      rocket_id: json['rocket_id'] as String,
      rocket_name: json['rocket_name'] as String,
      flickr_images: json['flickr_images'].cast<String>(),
    );
  }

  Rocket toModel() {
    return Rocket(
      id: rocket_id,
      name: rocket_name,
      imageUrl: flickr_images.isNotEmpty ? flickr_images.first : null,
    );
  }

  @override
  List<Object?> get props => [rocket_id, rocket_name, flickr_images];
}
