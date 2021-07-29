import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

class NxpressCore {
  List<NxpressNode> nodes = [];
  NxpressSchema? nxSchema;

  NxpressCore.parse(String nxContent, NxpressSchema nxSchema) {
    this.nxSchema = nxSchema;

    // split nodes from outside brackets and remove empty ones
    final rawNodes = nxContent.trim().split((RegExp(r"(})(?![^{]*\})")));
    rawNodes.removeWhere((node) => node.length == 0);

    // create nx nodes
    final nxNodes = _createNodes(rawNodes);

    // validate the schema
    final nxError = nxSchema.validateNodes(nxNodes);

    if (nxError.isError ?? false) {
      nxError.throwError();
    }

    print("Content parsed successfully");

    nodes = nxNodes;
  }

  List<NxpressNode> _createNodes(List<String> rawNodes) {
    List<NxpressNode> nxNodes = [];
    List<String> usedNodeNames = [];

    for (final node in rawNodes) {
      final splittedNode = node.split("{");
      final nodeName = splittedNode[0];

      if (usedNodeNames.contains(nodeName)) {
        throw FormatException("Duplicated node name: $nodeName");
      }

      usedNodeNames.add(nodeName);

      final nxNode = NxpressNode(nodeName: nodeName);
      final nodeKeyValues = splittedNode[1].split(",");

      var nxKeyValues = nodeKeyValues.map((kv) {
        final splittedkeyValue = kv.split(":");
        final key =
            splittedkeyValue[0].trim().replaceAll(new RegExp(r"\s+"), "");
        final value = splittedkeyValue[1].replaceAll('"', "");
        return NxpressKeyValue(key: key, value: value);
      }).toList();

      nxNode.nxpressKeyValue = nxKeyValues;

      nxNodes.add(nxNode);
    }

    return nxNodes;
  }

  String toDart() {
    var code = "import \"package:nxpress/nxpress.dart\";\n";
    code += "\nclass ${nxSchema?.schemaName} {";

    for (var node in nodes) {
      code += "\t\nstatic const ${node.nodeName} = NxpressResource(keys: ${node.toMapString()});";
    }

    code += "\n}";

    return code;
  }
}
