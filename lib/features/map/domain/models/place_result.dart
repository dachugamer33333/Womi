import '../../../../core/utils/json_utils.dart';

class PlaceResult {
  final String displayName;
  final String shortName;
  final double latitude;
  final double longitude;
  final String? type;

  const PlaceResult({
    required this.displayName,
    required this.shortName,
    required this.latitude,
    required this.longitude,
    this.type,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] is Map
        ? JsonUtils.safeMap(json['address'] as Map)
        : <String, dynamic>{};
    return PlaceResult(
      displayName: (json['display_name'] as String? ?? ''),
      shortName: (addr['road'] ?? addr['amenity'] ?? json['name'] ?? 'Sin nombre')
          .toString(),
      latitude: double.parse(json['lat'].toString()),
      longitude: double.parse(json['lon'].toString()),
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'shortName': shortName,
        'latitude': latitude,
        'longitude': longitude,
        'type': type,
      };
}
