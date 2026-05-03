import 'package:flutter/material.dart';
import '../../../auth/data/auth_repository.dart';
import '../../data/ride_repository.dart';
import '../../domain/models/destination_model.dart';
import '../../domain/models/ride_model.dart';

class RideProvider extends ChangeNotifier {
  final RideRepository _repository;

  RideProvider(AuthRepository authRepo)
      : _repository = RideRepository(authRepo);

  DestinationModel? _selectedDestination;
  RideModel? _currentRide;
  bool _isRideActive = false;
  bool _isSearching = false;

  DestinationModel? get selectedDestination => _selectedDestination;
  RideModel? get currentRide => _currentRide;
  bool get isRideActive => _isRideActive;
  bool get isSearching => _isSearching;

  void selectDestination(DestinationModel dest) {
    _selectedDestination = dest;
    _repository.selectDestination(dest);
    notifyListeners();
  }

  void clearSelection() {
    _selectedDestination = null;
    _repository.clearSelection();
    notifyListeners();
  }

  void startSearching() {
    _isSearching = true;
    notifyListeners();
  }

  void driverFound() {
    _isSearching = false;
    _currentRide = _repository.createRide(_selectedDestination!);
    _isRideActive = true;
    notifyListeners();
  }

  Future<void> completeRide() async {
    if (_currentRide != null) {
      await _repository.saveCompletedRide(_currentRide!);
    }
    _isRideActive = false;
    _currentRide = null;
    _selectedDestination = null;
    _isSearching = false;
    notifyListeners();
  }
}
