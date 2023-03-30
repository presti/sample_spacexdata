import 'package:sample_spacexdata/utils/equality.dart';

class Rocket extends Equality {
  final String id;
  final String name;
  final String? imageUrl;

  const Rocket({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, imageUrl];
}
