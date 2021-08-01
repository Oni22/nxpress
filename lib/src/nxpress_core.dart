import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

class NxpressCore {
  List<NxpressNode> nodes = [];
  NxpressSchema? nxSchema;
  String? resourceName;
  String? className;

  NxpressCore.parse(String nxContent, NxpressSchema nxSchema, String resourceName, String className) {
    this.nxSchema = nxSchema;
    this.resourceName = resourceName;
    this.className = className;

    // split nodes from outside brackets and remove empty ones
    final rawNodes = nxContent.trim().split((RegExp(r"(})(?![^{]*\})")));
    rawNodes.removeWhere((node) => node.length == 0);

    // create nx nodes
    final nxNodes = _createNodes(rawNodes);

    // validate the schema
    nxSchema.validateNodes(nxNodes);

    print("Content parsed successfully");

    nodes = nxNodes;
  }

  List<NxpressNode> _createNodes(List<String> rawNodes) {
    List<NxpressNode> nxNodes = [];
    List<String> usedNodeNames = [];

    for (final node in rawNodes) {
      final splittedNode = node.split("{");
      final nodeName = splittedNode[0].trim();

      if (usedNodeNames.contains(nodeName)) {
        throw FormatException("Duplicated node name: $nodeName");
      }

      usedNodeNames.add(nodeName);

      final nxNode = NxpressNode(nodeName: nodeName);
      final nodeKeyValues = splittedNode[1].split(RegExp(r"(,)(?![^[]*\])"));

      var nxKeyValues = nodeKeyValues.map((kv) {
        final splittedkeyValue = kv.split(":");
        final key = splittedkeyValue[0].trim().replaceAll(new RegExp(r"\s+"), "");
        final value = splittedkeyValue[1].trim().replaceAll('"', "");

        if (isArrayType(value)) {
          final values = value.replaceAll("[", "").replaceAll("]", "").replaceAll("\n", "").trim().split(",");
          return NxpressKeyValue(key: key, values: values);
        } else {
          return NxpressKeyValue(key: key, value: value);
        }
      }).toList();

      nxNode.nxpressKeyValue = nxKeyValues;

      nxNodes.add(nxNode);
    }

    return nxNodes;
  }

  isArrayType(String value) {
    return value.trim().startsWith("[") && value.trim().endsWith("]");
  }

  String toDart() {
    var code = "import 'package:nxpress/nxpress.dart';\nclass $className {";

    for (var node in nodes) {
      code += "\t\nstatic final ${node.nodeName?.trim()} = $resourceName(${node.toMapString().trim()});";
      print(code);
    }

    code += "\n}";

    return code;
  }
}
