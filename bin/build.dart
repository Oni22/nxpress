import 'package:nxpress/nxpress.dart';
import 'package:nxpress/src/models/nxpress_node.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/nxpress_core.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

main(List<String> args) async {

  buildNxStrings();

  String? namespace;

  if(args.length > 0) {
    namespace = args[0];
  }

  var relativePath = path.relative("lib/src/nxres/");
  final content = await File(relativePath + "/custom/schemas.nx").readAsString();

  final schemaParser = NxpressCore.parse(
    content,
    NxpressSchema(
      requiredKeys: ["requiredKeys","resourceName","customScript"],
      optionalKeys: ["optionalKeys"]
    ),
  );

  var relativeNamespacePath = path.relative("lib/src/nxres/resources/");

  if(namespace != null) {

    final currentNamespace = schemaParser.nodes.firstWhere((n) => n.nodeName == namespace);
    build(relativeNamespacePath, currentNamespace);

  } else {

    for(var node in schemaParser.nodes) {
      build(relativeNamespacePath, node);
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

build(String path,NxpressNode node) {
  createNamespace(path, node.nodeName ?? "unknown");
  final creator = buildResources(node);
  creator.build();
}

createNamespace(String path,String namespace) {
  var nxNamespace = Directory(path + "/$namespace");
  nxNamespace.createSync(recursive: true);
}

buildResources(NxpressNode node) {
  return NxpressCreator(
    customScript: node.getValue<String>("customScript"),
    namespace: node.nodeName ?? "unknown", 
    schema: NxpressSchema(
      requiredKeys: node.getStringList("requiredKeys"),
      optionalKeys: node.getStringList("optionalKeys")
      ), 
    resourceName: node.getValue<String>("resourceName"),
  );
}