import '../../auth/data/auth_repository.dart';
import '../domain/models/destination_model.dart';
import '../domain/models/driver_model.dart';
import '../domain/models/ride_model.dart';

class RideRepository {
  final AuthRepository _authRepository;

  RideRepository(this._authRepository);

  DestinationModel? _selectedDestination;
  DestinationModel? get selectedDestination => _selectedDestination;

  void selectDestination(DestinationModel dest) {
    _selectedDestination = dest;
  }

  void clearSelection() {
    _selectedDestination = null;
  }

  RideModel createRide(DestinationModel destination) {
    final dist = RideModel.calculateDistance(destination.location);
    final fare = RideModel.calculateCost(dist);
    final mins = RideModel.calculateEstimatedMinutes(dist);
    return RideModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      destination: destination,
      driver: DriverModel.anaMartinez,
      distanceKm: dist,
      estimatedMinutes: mins,
      costMxn: fare,
      actualMinutes: (mins + (DateTime.now().millisecond % 4)).clamp(5, 120),
      completedAt: DateTime.now(),
    );
  }

  Future<void> saveCompletedRide(RideModel ride) async {
    final activities = _authRepository.getActivities();
    activities.insert(0, ride.toJson());
    await _authRepository.saveActivities(activities);
  }
}
