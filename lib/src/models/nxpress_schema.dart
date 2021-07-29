

import 'package:nxpress/src/error_handler/nxpress_error_handler.dart';
import 'package:nxpress/src/models/nxpress_key_value.dart';
import 'package:nxpress/src/models/nxpress_node.dart';

class NxpressSchema {

  List<String>? requiredKeys;
  List<String>? optionalKeys;

  NxpressSchema({
    this.requiredKeys,
    this.optionalKeys,
  });

  NxpressErrorHandler validateNodes(List<NxpressNode> nodes) {

    for(var node in nodes) {

      for(var kv in node.nxpressKeyValue ?? <NxpressKeyValue>[]) {          
          if(requiredKeys?.contains(kv.key) == false && optionalKeys?.contains(kv.key) == false) {
            return NxpressErrorHandler(
              message: "Key ${kv.key} is not defined in schema at ${node.nodeName}!",
              isError: true
              );
          }
      }

      final missingRequiredKeys = requiredKeys?.where((requiredKey) => node.nxpressKeyValue?.any((keyValue) => keyValue.key == requiredKey) == false);

      if((missingRequiredKeys?.length ?? 0) > 0) {
        return NxpressErrorHandler(
            message: "Required keys are missing: ${missingRequiredKeys?.map((key) => key).toList()} at ${node.nodeName}!",
            isError: true
          );
      }
    }

    return NxpressErrorHandler(isError: false);

  }

}