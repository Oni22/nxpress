

import 'dart:convert';
import 'package:nxpress/nxpress.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

main(List<String> args) async {

  buildNxStrings();

  String? namespace;

  if(args.length > 0) {
    namespace = args[0];
  }

  var relativePath = path.relative("lib/src/nxres/");
  final content = await File(relativePath + "/custom/schemas.json").readAsString();
  final schemas = json.decode(content);

  var relativeNamespacePath = path.relative("lib/src/nxres/resources/");

  if(namespace != null) {

    final currentNamespace = schemas.firstWhere((n) => n["namespace"] == namespace);
    build(relativeNamespacePath, currentNamespace);

  } else {

    for(var schema in schemas) {
      build(relativeNamespacePath, schema);
    }

  }

}

buildNxStrings() {
  final creator = NxpressCreator(
    namespace: "strings", 
    schema: NxpressSchema(requiredKeys: []), 
    resourceName: "NxString"
  );

  creator.build();
}

build(String path,dynamic schema) {
  createNamespace(path, schema['namespace']);
  final creator = buildResources(schema);
  creator.build();
}

createNamespace(String path,String namespace) {
  var nxNamespace = Directory(path + "/$namespace");
  nxNamespace.createSync(recursive: true);
}

buildResources(dynamic namespace) {
  return NxpressCreator(
    customScript: namespace["customScript"],
    namespace: namespace["namespace"], 
    schema: NxpressSchema(
      requiredKeys: namespace["requiredKeys"].map<String>((s) => s.toString()).toList(),
      optionalKeys: namespace["optionalKeys"].map<String>((s) => s.toString()).toList()
      ), 
    resourceName: namespace["resourceName"]
  );
}