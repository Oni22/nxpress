class NxpressResource {
  final Map<String, Object>? keys;

  const NxpressResource({this.keys});

  getValue<T>(String key) {
    return (keys ?? {})[key] as T;
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

  List<String> getListValue(String key) {
    try {
      return getValue<List<String>>(key);
    } catch (err) {
      throw Exception("$key is not a type of List<String>. Please be sure that you use a List for plurals.");
    }
  }

  String setPlaceholders(String content, Map<String, Object> placeholders) {
    var finalContent = content;
    placeholders.forEach((name, value) {
      finalContent = finalContent.replaceFirst("{{$name}}", value.toString());
    });
    return finalContent;
  }
}
