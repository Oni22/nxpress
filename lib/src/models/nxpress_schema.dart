import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';

class NxpressSchema {
  final List<String>? requiredKeys;
  final List<String>? optionalKeys;
  final List<String>? requiredNodes;
  final bool onlyRequiredNodes;
  final Function(List<NxpressNode> nodes)? validator;

  const NxpressSchema({this.requiredKeys, this.optionalKeys, this.validator, this.requiredNodes, this.onlyRequiredNodes = false});

  bool validateNodes(List<NxpressNode> nodes) {
    validator?.call(nodes);

    if (onlyRequiredNodes) {
      if (nodes.any((node) => requiredNodes?.any((requiredNode) => requiredNode == node.nodeName?.trim()) == false)) {
        throw FormatException("Only required nodes are allowed");
      }
    }

    if ((requiredNodes?.length ?? 0) > 0) {
      final missingRequiredNodes = requiredNodes?.where((requiredNode) => nodes.any((node) => node.nodeName?.trim() == requiredNode.trim()) == false);

      if ((missingRequiredNodes?.length ?? 0) > 0) {
        throw FormatException("Required nodes are missing: ${missingRequiredNodes?.map((key) => key).toList()}!");
      }
    }

    for (var node in nodes) {
      if ((node.nxpressKeyValue?.length ?? 0) < 1) throw FormatException("Please add at least one key to ${node.nodeName}!");

      for (var kv in node.nxpressKeyValue ?? <NxpressKeyValue>[]) {
        if (requiredKeys?.contains(kv.key) == false && optionalKeys?.contains(kv.key) == false) {
          throw FormatException("Key ${kv.key} is not defined in schema at ${node.nodeName}!");
        }
      }

      final missingRequiredKeys = requiredKeys?.where((requiredKey) => node.nxpressKeyValue?.any((keyValue) => keyValue.key == requiredKey) == false);

      if ((missingRequiredKeys?.length ?? 0) > 0) {
        throw FormatException("Required keys are missing: ${missingRequiredKeys?.map((key) => key).toList()} at ${node.nodeName}!");
      }
    }

    return true;
  }
}
