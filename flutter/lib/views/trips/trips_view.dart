import 'package:flutter/material.dart';
import '../../providers/trip_provider.dart';
import '../../views/trips/widgets/trip_list.dart';
import '../../widgets/dyma_loader.dart';
import 'package:provider/provider.dart';
import '../../widgets/dyma_drawer.dart';

class TripsView extends StatelessWidget {
  static const String routeName = '/trips';

  @override
  Widget build(BuildContext context) {
    TripProvider tripProvider = Provider.of<TripProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes voyages'),
          bottom: const TabBar(
            tabs: <Widget>[
              const Tab(
                text: 'A venir',
              ),
              const Tab(
                text: 'Passés',
              ),
            ],
          ),
        ),
        drawer: const DymaDrawer(),
        body: tripProvider.isLoading != true
            ? tripProvider.trips.length > 0
                ? TabBarView(
                    children: <Widget>[
                      TripList(
                        trips: tripProvider.trips
                            .where((trip) =>
                                DateTime.now().isBefore(trip.date as DateTime))
                            .toList(),
                      ),
                      TripList(
                        trips: tripProvider.trips
                            .where((trip) =>
                                DateTime.now().isAfter(trip.date as DateTime))
                            .toList(),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text('Aucun voyage pour le moment'),
                  )
            : DymaLoader(),
      ),
    );
  }
}
