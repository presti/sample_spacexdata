import 'package:flutter/material.dart';
import 'package:sample_spacexdata/feature/launches/launches_page.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';

class RocketListing extends StatelessWidget {
  final Rocket rocket;

  const RocketListing(this.rocket, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = rocket.imageUrl;
    final image = imageUrl != null
        ? Ink.image(
            image: NetworkImage(
              imageUrl,
            ),
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            child: Hero(
              tag: rocket.id,
              child: const SizedBox(),
            ),
          )
        : const Icon(Icons.rocket_launch);
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute(builder: (context) => LaunchesPage(rocket)),
          );
        },
        child: Stack(
          children: [
            image,
            Center(
              child: Container(
                color: Colors.red,
                child: Text(rocket.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
