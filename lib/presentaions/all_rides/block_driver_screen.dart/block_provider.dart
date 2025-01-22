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

      final today = DateTime.now();
      final dateKey =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      for (var entry in driverStats.entries) {
        final driverId = entry.key;
        final stats = entry.value;

        if (stats is Map) {
          final driverData = Map<String, dynamic>.from(stats);
          driverData['id'] = driverId;

          try {
            // Fetch driver profile
            final driverDoc = await _firestore
                .collection('driverProfiles')
                .doc(driverId)
                .get();

            if (driverDoc.exists) {
              final profileData = driverDoc.data()!;
              driverData.addAll({
                'name': profileData['name'] ?? 'Unknown',
                'contactNumber': profileData['contactNumber'] ?? 'N/A',
                'profileImageUrl': profileData['profileImageUrl'] ?? '',
                'isBlockedInFirestore': profileData['isBlocked'] ?? false,
              });
            } else {
              driverData.addAll({
                'name': 'Unknown Driver',
                'contactNumber': 'N/A',
                'profileImageUrl': '',
                'isBlockedInFirestore': false,
              });
            }

            // Get today's cancellations
            final todayCancellationsSnapshot = await _database
                .child('dailyCancellations')
                .child(dateKey)
                .child(driverId)
                .get();

            final todayCancellations =
                (todayCancellationsSnapshot.value as int?) ?? 0;
            driverData['dailyCancellations'] = todayCancellations;

            if (todayCancellations >= 2 &&
                !(driverData['isBlocked'] ?? false)) {
              await _autoBlockDriver(driverId);
            }

            drivers.add(driverData);
          } catch (e) {
            print('Error processing driver $driverId: $e');
            drivers.add({
              ...driverData,
              'name': 'Error Loading Profile',
              'contactNumber': 'N/A',
              'profileImageUrl': '',
              'isBlockedInFirestore': false,
              'dailyCancellations': 0,
            });
          }
        }
      }

      return drivers;
    });
  }

  Future<void> recordCancellation(String driverId) async {
    try {
      final today = DateTime.now();
      final dateKey =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      // Update daily cancellations
      final dailyRef =
          _database.child('dailyCancellations').child(dateKey).child(driverId);

      final DataSnapshot snapshot = await dailyRef.get();
      final currentCount = (snapshot.value as int?) ?? 0;
      await dailyRef.set(currentCount + 1);

      // Update total cancellations
      final statsRef = _database.child('driverStats').child(driverId);
      await statsRef.update({
        'totalCancellations': ServerValue.increment(1),
      });

      notifyListeners();
    } catch (e) {
      print('Error recording cancellation: $e');
      throw Exception('Failed to record cancellation: $e');
    }
  }

  Future<void> resetDailyCancellations() async {
    try {
      final today = DateTime.now();
      final dateKey =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      // Remove today's cancellations node entirely
      await _database.child('dailyCancellations').child(dateKey).remove();

      notifyListeners();
    } catch (e) {
      print('Error resetting daily cancellations: $e');
      throw Exception('Failed to reset daily cancellations: $e');
    }
  }

  Future<void> _autoBlockDriver(String driverId) async {
    try {
      // Update Realtime Database
      await _database.child('driverStats/$driverId').update({
        'isBlocked': true,
        'lastBlockUpdate': ServerValue.timestamp,
        'blockReason': 'Automatically blocked due to excessive cancellations',
      });

      // Update Firestore
      await _firestore.collection('driverProfiles').doc(driverId).update({
        'isBlocked': true,
        'lastBlockUpdate': FieldValue.serverTimestamp(),
        'blockReason': 'Automatically blocked due to excessive cancellations'
      });

      notifyListeners();
    } catch (e) {
      print('Error auto-blocking driver: $e');
      throw Exception('Failed to block driver: $e');
    }
  }

  Future<void> toggleDriverBlock(
      String driverId, bool currentBlockStatus) async {
    try {
      final newBlockStatus = !currentBlockStatus;
      final blockReason = newBlockStatus ? 'Manually blocked by admin' : null;

      // Start both updates
      final Future realtimeUpdate =
          _database.child('driverStats/$driverId').update({
        'isBlocked': newBlockStatus,
        'lastBlockUpdate': ServerValue.timestamp,
        'blockReason': blockReason,
      });

      final Future firestoreUpdate =
          _firestore.collection('driverProfiles').doc(driverId).update({
        'isBlocked': newBlockStatus,
        'lastBlockUpdate': FieldValue.serverTimestamp(),
        'blockReason': blockReason,
      });

      // Wait for both updates to complete
      await Future.wait([realtimeUpdate, firestoreUpdate]);

      notifyListeners();
    } catch (e) {
      print('Error toggling driver block status: $e');
      throw Exception('Failed to update driver block status: $e');
    }
  }

  // Future<void> resetDailyCancellations() async {
  //   try {
  //     final statsSnapshot = await _database.child('driverStats').get();
  //     if (statsSnapshot.exists) {
  //       final Map<String, dynamic> realtimeUpdates = {};
  //       final stats = Map<String, dynamic>.from(statsSnapshot.value as Map);

  //       // Prepare batch for Firestore updates
  //       final batch = _firestore.batch();

  //       for (var driverId in stats.keys) {
  //         // Prepare Realtime Database updates
  //         realtimeUpdates['driverStats/$driverId/dailyCancellations'] = 0;
  //         realtimeUpdates['driverStats/$driverId/lastStatsReset'] =
  //             ServerValue.timestamp;

  //         // Prepare Firestore updates
  //         final driverRef =
  //             _firestore.collection('driverProfiles').doc(driverId);
  //         batch.update(driverRef, {
  //           'dailyCancellations': 0,
  //           'lastStatsReset': FieldValue.serverTimestamp(),
  //         });
  //       }

  //       // Execute both updates
  //       await Future.wait([
  //         _database.update(realtimeUpdates),
  //         batch.commit(),
  //       ]);

  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print('Error resetting daily cancellations: $e');
  //     throw Exception('Failed to reset daily cancellations: $e');
  //   }
  // }

  // Helper method to verify database consistency
  Future<void> verifyDatabaseConsistency(String driverId) async {
    try {
      final realtimeSnapshot =
          await _database.child('driverStats/$driverId').get();
      final firestoreSnapshot =
          await _firestore.collection('driverProfiles').doc(driverId).get();

      if (realtimeSnapshot.exists && firestoreSnapshot.exists) {
        final realtimeData =
            Map<String, dynamic>.from(realtimeSnapshot.value as Map);
        final firestoreData = firestoreSnapshot.data()!;

        if (realtimeData['isBlocked'] != firestoreData['isBlocked']) {
          // Fix inconsistency
          await Future.wait([
            _database.child('driverStats/$driverId').update({
              'isBlocked': firestoreData['isBlocked'],
            }),
            _firestore.collection('driverProfiles').doc(driverId).update({
              'isBlocked': realtimeData['isBlocked'],
            }),
          ]);
        }
      }
    } catch (e) {
      print('Error verifying database consistency: $e');
    }
  }
}
