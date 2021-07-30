import 'package:nxpress/nxpress.dart';
import 'package:nxpress/src/models/nxpress_class.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

part 'my-resource.g.dart';

@NxpressClass(
  source: "strings", 
  schema: NxpressSchema(
    className: "Test", 
    requiredKeys: ["en", "de"], 
    optionalKeys: ["tr", "fr"], 
  )
)
class RStrings extends NxpressResource {
  RStrings(Map<String, String> keys) : super(keys: keys);
}
