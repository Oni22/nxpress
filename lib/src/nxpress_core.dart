import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

class NxpressCore {
  List<NxpressNode> nodes = [];

  NxpressCore.parse(String nxContent, NxpressSchema nxSchema) {

    // split nodes from outside brackets and remove empty ones
    final rawNodes = nxContent.trim().split(RegExp(r'(,)(?![^[]*\])(?![^"\n]*\")(?![^{]*\})'));
    print(rawNodes);
    rawNodes.removeWhere((node) => node.length == 0);
    final nxNodes = _createNodes(rawNodes);

    // validate the schema
    nxSchema.validateNodes(nxNodes);

    print("Content parsed successfully");

    nodes = nxNodes;
  }

  // TODO validate key values format with commas
  // validate arrays syntax
  NxNodeData validateNodeSyntax(String rawNode) {

    final node = rawNode.trim();
    if(node.contains("[TT_OPAREN]") || node.contains("[TT_CPAREN]")) {
      throw FormatException("Nxpress ERROR: [TT_OPAREN] and [TT_CPAREN] are not allowed! These keys are reserved by Nxpress parser.");
    }
    
    var tokenNode = node.replaceFirst("{","[TT_OPAREN]").trim();
  
    final nodeName = tokenNode.split("[TT_OPAREN]")[0].trim();
    final hasNodeNameSpecialChars = nodeName.contains(RegExp(r'[^A-Za-z0-9_]'));
    if(hasNodeNameSpecialChars) throw FormatException("Nxpress ERROR: Only underscores are allowed in node names. At -> $nodeName"); 

    if(!tokenNode.endsWith("}")) throw FormatException("Nxpress ERROR: No closing brace! At -> $nodeName"); 

    tokenNode = tokenNode.substring(0,tokenNode.length - 1) + "[TT_CPAREN]";
    var nodeContent = tokenNode.split("[TT_OPAREN]")[1].replaceAll("[TT_CPAREN]","").trim();
  
    final regexOpenCurly= RegExp(r"""{(?=([^'"]*['"][^'"]*['"])*[^'"]*$)""");
    final regexCloseCurly = RegExp(r"""}(?=([^'"]*['"][^'"]*['"])*[^'"]*$)""");

    if (regexOpenCurly.allMatches(nodeContent).length > 0) throw FormatException("Node $nodeName has invalid syntax!");
    if (regexCloseCurly.allMatches(nodeContent).length > 0) throw FormatException("Node $nodeName has invalid syntax!");


    return NxNodeData(nodeName: nodeName,nodeContent: nodeContent);

  }

  List<NxpressNode> _createNodes(List<String> rawNodes) {
    List<NxpressNode> nxNodes = [];
    List<String> usedNodeNames = [];

    for (final node in rawNodes) {

      final nodeData = validateNodeSyntax(node);

      if (usedNodeNames.contains(nodeData.nodeName)) {
        throw FormatException("Duplicated node name: ${nodeData.nodeName}");
      }

      usedNodeNames.add(nodeData.nodeName ?? "unknown");

      final nxNode = NxpressNode(nodeName: nodeData.nodeName);
      final nodeKeyValues = nodeData.nodeContent?.trim().split(RegExp(r""",(?=([^'"]*['"][^'"]*['"])*[^'"]*$)"""));
   
      print(nodeKeyValues);
      var nxKeyValues = nodeKeyValues?.map((kv) {
        final splittedkeyValue = kv.split(":");
        final key = splittedkeyValue[0].trim();
        final value = splittedkeyValue[1].replaceAll("\"", "");

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

  String toDart(String className, String resourceName, {String customScript = ""}) {
    var injectScript = customScript != "" ? "\nimport '/src/nxres/custom/${customScript.trim()}';" : "import 'package:nxpress/nxpress.dart';";
    var code = "$injectScript\nclass $className {";

    for (var node in nodes) {
      code += "\t\nstatic final ${node.nodeName?.trim()} = $resourceName(${node.toMapString().trim()});";
      print(code);
    }

    code += "\n}";

    return code;
  }
}

class NxNodeData {
  String? nodeName;
  String? nodeContent;
  NxNodeData({this.nodeContent,this.nodeName});
}
