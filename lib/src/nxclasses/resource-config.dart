
import 'package:nxpress/src/models/nxpress_resource.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/models/nxpress_wrapper.dart';

part 'resource-config.g.dart';

@NxpressWrapper(
  generateClass: "RConfig", 
  source: "config", 
  schema: NxpressSchema(requiredKeys: ["backupLang", "defaultLang"], optionalKeys: [], requiredNodes: ["myNode"], onlyRequiredNodes: true))
class ResourceConfig extends NxpressResource {
  ResourceConfig(Map<String, Object> keys) : super(keys: keys);
}
