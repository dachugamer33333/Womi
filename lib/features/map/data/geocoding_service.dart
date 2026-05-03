import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/json_utils.dart';
import '../domain/models/place_result.dart';

class GeocodingException implements Exception {
  final String message;
  const GeocodingException(this.message);
  @override
  String toString() => 'GeocodingException: $message';
}

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  Future<List<PlaceResult>> search(String query) async {
    if (query.trim().length < 3) return [];
    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
      'q': query,
      'format': 'json',
      'limit': '8',
      'countrycodes': 'mx',
      'addressdetails': '1',
      'accept-language': 'es',
    });
    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'WomiApp/1.0 (prototype)'},
      );
      if (response.statusCode != 200) {
        throw GeocodingException(
            'Error al buscar lugares: ${response.statusCode}');
      }
      final List data = jsonDecode(response.body) as List;
      return data.map((e) => PlaceResult.fromJson(JsonUtils.safeMap(e))).toList();
    } catch (e) {
      if (e is GeocodingException) rethrow;
      throw GeocodingException('Error de conexión. Verifica tu internet.');
    }
  }
}
