class DriverModel {
  final String name;
  final double rating;
  final int totalTrips;
  final String carModel;
  final String licensePlate;
  final bool isVerified;

  const DriverModel({
    required this.name,
    required this.rating,
    required this.totalTrips,
    required this.carModel,
    required this.licensePlate,
    this.isVerified = true,
  });

  static const anaMartinez = DriverModel(
    name: 'Ana Martínez',
    rating: 4.9,
    totalTrips: 1247,
    carModel: 'Nissan Versa Blanco',
    licensePlate: 'ABC-123',
    isVerified: true,
  );

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    return parts.length > 1
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first[0].toUpperCase();
  }
}
