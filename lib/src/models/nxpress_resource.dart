class NxpressResource {
  final Map<String, Object>? keys;

  const NxpressResource({this.keys});

  getValue<T>(String key) {
    return keys?.keys.firstWhere((k) => k == key) as T;
  }

  int getIntValue(String key) {
    return int.parse(getValue(key));
  }

  double getDoubleValue(String key) {
    return double.parse(getValue(key));
  }

  bool getBoolValue(String key) {
    return getValue(key) == "true";
  }

  String getStringValue(String key) {
    return getValue(key).toString();
  }

  String setPlaceholder(String content, String name, String value) {
    return content.replaceFirst("{{$name}}", value);
  }
}
