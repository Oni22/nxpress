

import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

class NxpressParser {

  List<NxpressNode> nodes = [];

  NxpressParser.parse(String nxContent,NxpressSchema nxSchema) {

    // split nodes from outside brackets and remove empty ones
    final rawNodes = nxContent.trim().split((RegExp(r"(})(?![^{]*\})")));
    rawNodes.removeWhere((node) => node.length == 0);
    
    // create nx nodes
    final nxNodes = _createNodes(rawNodes);

    // validate the schema 
    final nxError = nxSchema.validateNodes(nxNodes);

    if(nxError.isError ?? false) {
      nxError.throwError();
    }

    print("Content parsed successfully");
    
    nodes = nxNodes;

  }

  List<NxpressNode> _createNodes(List<String> rawNodes) {
    print("RAW NODES:" + rawNodes.length.toString() + rawNodes.toString());
    List<NxpressNode> nxNodes = [];

    for(final node in rawNodes) {
      final splittedNode = node.split("{");
      final nodeName = splittedNode[0];

      final nxNode = NxpressNode(nodeName: nodeName);
      final nodeKeyValues = splittedNode[1].split(",");

      var nxKeyValues = nodeKeyValues.map((kv) {
          final splittedkeyValue = kv.split(":");
          final key = splittedkeyValue[0].trim().replaceAll(new RegExp(r"\s+"), "");
          final value = splittedkeyValue[1].replaceAll('"',"");
          return NxpressKeyValue(key:key,value:value);
      }).toList();
    
      nxNode.nxpressKeyValue = nxKeyValues;

      nxNodes.add(nxNode);
    }

    return nxNodes;

  }

  String toDart() {

    return "SUCCESS";

  }


}