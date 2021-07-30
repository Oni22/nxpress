class NxpressKeyValue {
  String? key;
  String? value;
  List<String>? values;

  NxpressKeyValue({this.key, this.value, this.values});

  isArray() {
    return (values?.length ?? 0) > 0;
  }

  arrayValuesToString() {
    return values?.map((e) => "\"$e\"").toList().join(",");
  }
}
