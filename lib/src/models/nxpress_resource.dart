class NxpressResource {
  final Map<String, Object>? keys;

  const NxpressResource({this.keys});

  getValue<T>(String key) {
    return keys?.keys.firstWhere((k) => k == key) as T;
  }

  getIntValue(String key) {
    return int.parse(getValue(key));
  }

  getDoubleValue(String key) {
    return double.parse(getValue(key));
  }

  getBoolValue(String key) {
    return getValue(key) == "true";
  }

}
