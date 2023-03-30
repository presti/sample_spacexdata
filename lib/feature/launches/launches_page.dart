import 'package:flutter/material.dart';
import 'package:sample_spacexdata/feature/launches/data/launch.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket.dart';
import 'package:sample_spacexdata/feature/rockets/data/rocket_repository.dart';
import 'package:sample_spacexdata/res/strings.dart';
import 'package:sample_spacexdata/utils/date_time_utils.dart';
import 'package:sample_spacexdata/utils/functional/may.dart';
import 'package:sample_spacexdata/utils/rx/future_data.dart';

class LaunchesPage extends StatefulWidget {
  final Rocket rocket;

  const LaunchesPage(this.rocket, {Key? key}) : super(key: key);

  @override
  State<LaunchesPage> createState() => _LaunchesPageState();
}

class _LaunchesPageState extends State<LaunchesPage> {
  late final FutureData<List<Launch>, Failure> launches;

  @override
  void initState() {
    super.initState();

    launches = FutureData<List<Launch>, Failure>(() {
      return RocketRepository.i.getLaunches(widget.rocket);
    })
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.launchesTitle(widget.rocket.name)),
      ),
      body: Stack(
        children: [
          Hero(
            tag: widget.rocket.id,
            child: Image.network(
              widget.rocket.imageUrl!,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              opacity: const AlwaysStoppedAnimation(.5),
            ),
          ),
          launches.builder((mayLaunches, isLoading) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return mayLaunches!.on(
                onSuccess: (launches) {
                  if (launches.isEmpty) {
                    return Center(child: Text(context.s.launchesEmpty));
                  }

                  return ListView(
                    children: [
                      for (final launch in launches)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(DateTimeUtils.i.format(launch.dateTime)),
                        )
                    ],
                  );
                },
                onFailure: (f) => Text(context.s.error),
              );
            }
          }),
        ],
      ),
    );
  }
}
