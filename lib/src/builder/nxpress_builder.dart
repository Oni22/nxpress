import 'package:build/build.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/nxpress_parser.dart';

class NxpressBuilder implements Builder {

  @override
  Map<String, List<String>> get buildExtensions => {
        ".nx": [".nx.dart"]
      };


  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final copyInputId = inputId.changeExtension(".nx.dart");

    var contents = await buildStep.readAsString(inputId);
    
    var schema = new NxpressSchema(
      requiredKeys: ["de","en"],
      optionalKeys: ["fr","tr"]
    ); 

    var nxparser = new NxpressParser.parse(contents, schema);

    await buildStep.writeAsString(copyInputId, nxparser.toDart());
  }
}
