import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../views/trip/trip_view.dart';
import '../../../models/trip_model.dart';

class TripList extends StatelessWidget {
  final List<Trip> trips;

  const TripList({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, i) {
        var trip = trips[i];
        return ListTile(
          title: Text(trip.city),
          subtitle: trip.date != null
              ? Text(DateFormat("d/M/y").format(trip.date as DateTime))
              : null,
          trailing: const Icon(Icons.info),
          onTap: () {
            Navigator.pushNamed(
              context,
              TripView.routeName,
              arguments: {'tripId': trip.id as String, 'cityName': trip.city},
            );
          },
        );
      },
    );
  }
}
