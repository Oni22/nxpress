import 'package:nxpress/src/creator/nxpress_creator.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

main(List<String> args) async {
  final creator = NxpressCreator(
    namespace: "strings", 
    schema: NxpressSchema(requiredKeys: []), 
    resourceName: "NxString"
  );

  creator.build();
}
