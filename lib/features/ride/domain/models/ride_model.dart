import 'package:latlong2/latlong.dart';
import 'destination_model.dart';
import 'driver_model.dart';

class RideModel {
  final String id;
  final DestinationModel destination;
  final DriverModel driver;
  final double distanceKm;
  final int estimatedMinutes;
  final double costMxn;
  final int actualMinutes;
  final DateTime completedAt;

  const RideModel({
    required this.id,
    required this.destination,
    required this.driver,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.costMxn,
    required this.actualMinutes,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': 'Viaje a ${destination.name}',
        'address': destination.address,
        'driverName': driver.name,
        'driverRating': driver.rating,
        'distanceKm': distanceKm,
        'costMxn': costMxn,
        'actualMinutes': actualMinutes,
        'completedAt': completedAt.toIso8601String(),
      };

  static const LatLng simulatedOrigin = DestinationModel.simulatedOrigin;

  static double calculateDistance(LatLng dest) {
    return const Distance().as(
      LengthUnit.Kilometer,
      simulatedOrigin,
      dest,
    );
  }

  static int calculateEstimatedMinutes(double km) {
    return (km / 30 * 60).round().clamp(5, 120);
  }

  static double calculateCost(double km) {
    const tasaBase = 25.0;
    const costoPorKm = 8.0;
    return tasaBase + (km * costoPorKm);
  }
}
