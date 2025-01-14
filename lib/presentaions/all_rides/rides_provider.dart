import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';

class TripProvider with ChangeNotifier {
  final DatabaseReference _tripRef = FirebaseDatabase.instance.ref('bookings');
  List<Trip> _trips = [];
  bool _isLoading = false;
  String? _error;

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Trip> get completedTrips {
    print('\nDEBUG: Checking all trip statuses:');
    for (var trip in _trips) {
      print('Trip ID: ${trip.tripId}');
      print('Original status: "${trip.status}"');
      print('Lowercase status: "${trip.status.toLowerCase()}"');
      print('Is completed? ${trip.status.toLowerCase() == 'trip completed'}');
      print('---');
    }

    final completed = _trips
        .where((trip) => trip.status.toLowerCase() == 'trip completed')
        .toList();

    print('\nTotal trips: ${_trips.length}');
    print('Completed trips found: ${completed.length}');
    return completed;
  }

  Future<void> fetchTrips() async {
    print('Starting fetchTrips()');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Fetching data from Firebase...');
      final snapshot = await _tripRef.get();
      print('Raw snapshot value: ${snapshot.value}');

      if (snapshot.value != null) {
        print('Snapshot is not null');
        _trips = [];

        if (snapshot.value is Map) {
          print('Snapshot value is a Map');
          final data = snapshot.value as Map<dynamic, dynamic>;
          print('Number of entries in data: ${data.length}');

          data.forEach((key, value) {
            print('Processing entry with key: $key');
            if (value is Map<dynamic, dynamic>) {
              try {
                print('Value for key $key: $value');
                final trip = Trip.fromJson(value, key.toString());
                print('Successfully parsed trip: ${trip.tripId}');
                _trips.add(trip);
              } catch (e) {
                print('Error parsing trip $key: $e');
                print('Value that caused error: $value');
              }
            } else {
              print('Value is not a Map: ${value.runtimeType}');
            }
          });

          print('Finished processing all entries');
          print('Total trips parsed: ${_trips.length}');

          // Sort by timestamp
          _trips.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          print('Trips sorted by timestamp');
        } else {
          print('Snapshot value is not a Map: ${snapshot.value.runtimeType}');
        }
      } else {
        print('Snapshot value is null');
      }
    } catch (e) {
      _error = 'Failed to fetch trips: $e';
      print('Error fetching trips: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      _isLoading = false;
      print('Fetch completed. Total trips: ${_trips.length}');
      notifyListeners();
    }
  }

  void startRealtimeUpdates() {
    print('Starting realtime updates');
    _tripRef.onValue.listen(
      (event) {
        print('Received realtime update');
        print('Raw event value: ${event.snapshot.value}');

        if (event.snapshot.value != null) {
          _trips = [];

          if (event.snapshot.value is Map) {
            final data = event.snapshot.value as Map<dynamic, dynamic>;
            print('Number of entries in realtime data: ${data.length}');

            data.forEach((key, value) {
              if (value is Map<dynamic, dynamic>) {
                try {
                  final trip = Trip.fromJson(value, key.toString());
                  _trips.add(trip);
                  print('Added trip: ${trip.tripId}');
                } catch (e) {
                  print('Error parsing realtime trip $key: $e');
                  print('Value that caused error: $value');
                }
              }
            });

            print('Finished processing realtime updates');
            print('Total trips after update: ${_trips.length}');
            _trips.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          } else {
            print(
                'Realtime snapshot is not a Map: ${event.snapshot.value.runtimeType}');
          }

          notifyListeners();
        } else {
          print('Realtime snapshot value is null');
        }
      },
      onError: (error) {
        _error = 'Error in realtime updates: $error';
        print('Error in realtime updates: $error');
        notifyListeners();
      },
    );
  }
}
