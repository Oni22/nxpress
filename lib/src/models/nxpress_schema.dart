import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';

class NxpressSchema {
  final List<String>? requiredKeys;
  final List<String>? optionalKeys;
  final String? className;
  final Function(List<NxpressNode> nodes)? validator;

  const NxpressSchema({this.requiredKeys, this.optionalKeys, this.className, this.validator});

  bool validateNodes(List<NxpressNode> nodes) {
    
    validator?.call(nodes);

    for (var node in nodes) {
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
