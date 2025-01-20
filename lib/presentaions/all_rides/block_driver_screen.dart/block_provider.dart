import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class DriverState extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> get driversStream {
    return _database.child('driverStats').onValue.asyncMap((event) async {
      final driverStats =
          Map<String, dynamic>.from(event.snapshot.value as Map? ?? {});
      List<Map<String, dynamic>> drivers = [];

      for (var entry in driverStats.entries) {
        final driverId = entry.key;
        final stats = entry.value;

        if (stats is Map) {
          // Create base driver data from Realtime Database
          final driverData = Map<String, dynamic>.from(stats);
          driverData['id'] = driverId;

          // Fetch driver profile from Firestore
          try {
            final driverDoc = await _firestore
                .collection('driverProfiles')
                .doc(driverId)
                .get();

            if (driverDoc.exists) {
              // Add Firestore profile data to driver data
              final profileData = driverDoc.data()!;
              driverData['name'] = profileData['name'] ?? 'Unknown';
              driverData['contactNumber'] =
                  profileData['contactNumber'] ?? 'N/A';
              driverData['profileImageUrl'] =
                  profileData['profileImageUrl'] ?? '';
            } else {
              // Set default values if profile not found
              driverData['name'] = 'Unknown Driver';
              driverData['contactNumber'] = 'N/A';
              driverData['profileImageUrl'] = '';
            }
          } catch (e) {
            print('Error fetching driver profile for $driverId: $e');
            // Set default values in case of error
            driverData['name'] = 'Error Loading Profile';
            driverData['contactNumber'] = 'N/A';
            driverData['profileImageUrl'] = '';
          }

          // Get cancellation counts
          final dailyCancellations = stats['dailyCancellations'] ?? 0;

          // Auto-block logic for drivers with 2 or more cancellations
          if (dailyCancellations >= 2 && !(stats['isBlocked'] ?? false)) {
            await _autoBlockDriver(driverId);
          }

          drivers.add(driverData);
        }
      }

      return drivers;
    });
  }

  Future<void> _autoBlockDriver(String driverId) async {
    try {
      await _database.child('driverStats/$driverId').update({
        'isBlocked': true,
        'lastBlockUpdate': ServerValue.timestamp,
        'blockReason': 'Automatically blocked due to excessive cancellations',
      });
      notifyListeners();
    } catch (e) {
      print('Error auto-blocking driver: $e');
    }
  }

  Future<void> toggleDriverBlock(
      String driverId, bool currentBlockStatus) async {
    try {
      await _database.child('driverStats/$driverId').update({
        'isBlocked': !currentBlockStatus,
        'lastBlockUpdate': ServerValue.timestamp,
        'blockReason': !currentBlockStatus ? 'Manually blocked by admin' : null,
      });
      notifyListeners();
    } catch (e) {
      print('Error toggling driver block status: $e');
      rethrow;
    }
  }

  Future<void> resetDailyCancellations() async {
    try {
      final statsSnapshot = await _database.child('driverStats').get();
      if (statsSnapshot.exists) {
        final Map<String, dynamic> updates = {};
        final stats = Map<String, dynamic>.from(statsSnapshot.value as Map);

        stats.forEach((driverId, _) {
          updates['driverStats/$driverId/dailyCancellations'] = 0;
          updates['driverStats/$driverId/lastStatsReset'] =
              ServerValue.timestamp;
        });

        await _database.update(updates);
        notifyListeners();
      }
    } catch (e) {
      print('Error resetting daily cancellations: $e');
      rethrow;
    }
  }
}
