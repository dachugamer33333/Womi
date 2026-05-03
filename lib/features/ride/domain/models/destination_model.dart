import 'package:latlong2/latlong.dart';

class DestinationModel {
  final String name;
  final String address;
  final LatLng location;
  final String iconLabel;

  const DestinationModel({
    required this.name,
    required this.address,
    required this.location,
    this.iconLabel = '',
  });

  static List<DestinationModel> cdmxDestinations() => const [
        DestinationModel(
          name: 'Casa',
          address: 'Av. Insurgentes Sur 1234, Del Valle',
          location: LatLng(19.3753, -99.1733),
          iconLabel: 'C',
        ),
        DestinationModel(
          name: 'Trabajo',
          address: 'Reforma 222, Cuauhtémoc',
          location: LatLng(19.4280, -99.1664),
          iconLabel: 'T',
        ),
        DestinationModel(
          name: 'Universidad',
          address: 'FES Aragón, UNAM',
          location: LatLng(19.4807, -99.0653),
          iconLabel: 'U',
        ),
        DestinationModel(
          name: 'Centro Comercial',
          address: 'Antara Polanco',
          location: LatLng(19.4408, -99.2073),
          iconLabel: 'CC',
        ),
        DestinationModel(
          name: 'Aeropuerto',
          address: 'AICM Terminal 1',
          location: LatLng(19.4361, -99.0719),
          iconLabel: 'A',
        ),
      ];

  static const LatLng simulatedOrigin = LatLng(19.4326, -99.1332);
}
