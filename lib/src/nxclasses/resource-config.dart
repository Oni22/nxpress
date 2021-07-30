import 'package:nxpress/nxpress.dart';

part 'resource-config.g.dart';

@NxpressClass(
  generateClass: "RConfig", 
  source: "config", 
  schema: NxpressSchema(
    requiredKeys: ["backupLang", "defaultLang"], 
    optionalKeys: [],
    requiredNodes: ["myNode"]
  ) 
)
class ResourceConfig extends NxpressResource {
  ResourceConfig(Map<String, Object> keys) : super(keys: keys);
}
