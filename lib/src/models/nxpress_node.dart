import 'package:nxpress/src/models/nxpress_key_value.dart';

class NxpressNode {

  String? nodeName;
  List<NxpressKeyValue>? nxpressKeyValue;

  NxpressNode({this.nodeName, this.nxpressKeyValue});

  toMapString() {
    Map<String, String> keyValues = {};

    var mapString = "{";

    for (var node in nxpressKeyValue ?? <NxpressKeyValue>[]) {
      mapString += "\"${node.key?.trim()}\":\"${node.value?.trim()}\",";
    }

    mapString += "}";

    return mapString;
  }
}
