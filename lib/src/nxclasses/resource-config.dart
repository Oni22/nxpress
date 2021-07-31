import 'package:nxpress/nxpress.dart';

part 'resource-config.g.dart';

@NxpressWrapper(
  generateClass: "RConfig", 
  source: "config", 
  schema: NxpressSchema(
    requiredKeys: ["backupLang", "defaultLang"], 
    optionalKeys: [], 
    requiredNodes: ["myNode"], 
    onlyRequiredNodes: true))
class ResourceConfig extends NxpressResource {
  ResourceConfig(Map<String, Object> keys) : super(keys: keys);
}
