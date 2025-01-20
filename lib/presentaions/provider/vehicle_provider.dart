import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/data/model/vehicle_model.dart';
import 'package:zoomio_adminzoomio/data/services/database.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _repository = VehicleRepository();
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;

  // Fetch vehicles with debug prints
  Future<void> fetchVehicles() async {
    try {
      print('Starting to fetch vehicles...'); // Debug print
      _isLoading = true;
      notifyListeners();

      _vehicles = await _repository.getVehicles();

      print('Fetched ${_vehicles.length} vehicles:'); // Debug print
      for (var vehicle in _vehicles) {
        print('Vehicle ID: ${vehicle.id}'); // Debug print
        print('Type: ${vehicle.vehicleType}'); // Debug print
        print('Brand: ${vehicle.brand}'); // Debug print
        print('-------------------'); // Debug print
      }

      _isLoading = false;
      notifyListeners();
      print('Finished fetching vehicles'); // Debug print
    } catch (e) {
      print('Error fetching vehicles: $e'); // Debug print
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get cars with debug
  List<Vehicle> get cars {
    final carsList = _vehicles
        .where((vehicle) => vehicle.vehicleType.trim().toLowerCase() == 'car')
        .toList();
    print(
        'Filtered ${carsList.length} cars from ${_vehicles.length} vehicles'); // Debug print
    return carsList;
  }

  // Get bikes with debug
  List<Vehicle> get bikes {
    final bikesList = _vehicles
        .where((vehicle) => vehicle.vehicleType.trim().toLowerCase() == 'bike')
        .toList();
    print(
        'Filtered ${bikesList.length} bikes from ${_vehicles.length} vehicles'); // Debug print
    return bikesList;
  }

  // Add vehicle
  Future<void> addVehicle(Vehicle newVehicle) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.addVehicle(newVehicle);

      // Add to local list immediately
      _vehicles.add(newVehicle);

      // Refresh the list to ensure consistency
      await fetchVehicles();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error adding vehicle: $e');
      rethrow;
    }
  }

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.updateVehicle(vehicle);

      // Update local state
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _vehicles[index] = vehicle;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error updating vehicle: $e');
      rethrow;
    }
  }

  // Delete vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.deleteVehicle(vehicleId);

      // Update local state
      _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error deleting vehicle: $e');
      rethrow;
    }
  }
}
