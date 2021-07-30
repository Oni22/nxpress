import 'package:nxpress/src/error_handler/nxpress_error_handler.dart';
import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';

import '../error_handler/nxpress_error_handler.dart';

class NxpressSchema {
  final List<String>? requiredKeys;
  final List<String>? optionalKeys;
  final String? className;

  const NxpressSchema({
    this.requiredKeys,
    this.optionalKeys,
    this.className,
  });

  NxpressValidator validateNodes(List<NxpressNode> nodes) {
    for (var node in nodes) {
      for (var kv in node.nxpressKeyValue ?? <NxpressKeyValue>[]) {
        if (requiredKeys?.contains(kv.key) == false && optionalKeys?.contains(kv.key) == false) {
          return NxpressValidator(message: "Key ${kv.key} is not defined in schema at ${node.nodeName}!", isError: true);
        }
      }

      final missingRequiredKeys = requiredKeys?.where((requiredKey) => node.nxpressKeyValue?.any((keyValue) => keyValue.key == requiredKey) == false);

      if ((missingRequiredKeys?.length ?? 0) > 0) {
        return NxpressValidator(message: "Required keys are missing: ${missingRequiredKeys?.map((key) => key).toList()} at ${node.nodeName}!", isError: true);
      }
    }

    return NxpressValidator(isError: false);
  }
}
