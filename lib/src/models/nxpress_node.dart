import 'package:nxpress/src/models/nxpress_key_value.dart';

class NxpressNode {
  String? nodeName;
  List<NxpressKeyValue>? nxpressKeyValue;

  NxpressNode({this.nodeName, this.nxpressKeyValue});

  toMapString() {

    var mapString = "{";

    for (var node in nxpressKeyValue ?? <NxpressKeyValue>[]) {
      if (node.isArray()) {
        mapString += "\"${node.key?.trim()}\":[${node.arrayValuesToString()}],";
      } else {
        mapString += "\"${node.key?.trim()}\":\"${node.value?.trim()}\",";
      }
    }

    mapString += "}";

    return mapString;
  }
}
