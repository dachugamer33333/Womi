class JsonUtils {
  JsonUtils._();

  /// Convierte un Map dinamico (de Hive o JSON) a su tipo correcto.
  /// De forma recursiva. Evita el error:
  ///   `type '_Map' is not a subtype of 'Map'`
  static Map<String, dynamic> safeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) {
        final k = key.toString();
        if (val is Map) return MapEntry(k, safeMap(val));
        if (val is List) return MapEntry(k, _safeList(val));
        return MapEntry(k, val);
      });
    }
    throw ArgumentError(
        'Expected Map<String, dynamic> but got ${value.runtimeType}');
  }

  static List<Map<String, dynamic>> safeListOfMaps(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => safeMap(e)).toList();
    }
    throw ArgumentError(
        'Expected List but got ${value.runtimeType}');
  }

  static List<dynamic> _safeList(List list) {
    return list.map((item) {
      if (item is Map) return safeMap(item);
      if (item is List) return _safeList(item);
      return item;
    }).toList();
  }
}
