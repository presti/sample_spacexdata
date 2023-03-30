import 'package:flutter/material.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket_repository.dart';
import 'package:sample_spacexdata/feature/rockets/ui/rocket_listing.dart';
import 'package:sample_spacexdata/res/strings.dart';
import 'package:sample_spacexdata/utils/functional/may.dart';
import 'package:sample_spacexdata/utils/rx/future_data.dart';

class RocketsPage extends StatefulWidget {
  const RocketsPage({Key? key}) : super(key: key);

  @override
  State<RocketsPage> createState() => _RocketsPageState();
}

class _RocketsPageState extends State<RocketsPage> {
  final rockets =
      FutureData<List<Rocket>, Failure>(RocketRepository.i.getRockets)..load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.homeTitle),
      ),
      body: Center(
        child: rockets.builder((mayRockets, isLoading) {
          if (isLoading) {
            return const CircularProgressIndicator();
          } else {
            return mayRockets!.on(
              onSuccess: (rockets) {
                return ListView(
                  children: [
                    for (final rocket in rockets)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: RocketListing(rocket),
                      )
                  ],
                );
              },
              onFailure: (f) => Text(context.s.error),
            );
          }
        }),
      ),
    );
  }
}
