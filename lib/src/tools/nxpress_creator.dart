import 'dart:io';

import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/nxpress_core.dart';
import 'package:path/path.dart' as path;

class NxpressCreator {
  final String namespace;
  final NxpressSchema schema;
  final String resourceName;
  String customScript = "";

  NxpressCreator({required this.namespace, required this.schema, required this.resourceName,this.customScript = ""});

  Future<void> build() async {
    var relativePath = path.relative("lib/src/nxres/resources/$namespace");

    final fileEntities = Directory(relativePath).listSync(recursive: true);
    fileEntities.removeWhere((element) => path.extension(element.path) != ".nx");
    var contents = "";

    for (var fileEntity in fileEntities) {
      final file = File(fileEntity.path);
      contents += await file.readAsString();
    }

    final wrapperClassName = resourceName + "s";
    final nxParser = NxpressCore.parse(contents, schema);

    await File(relativePath + "/${wrapperClassName.toLowerCase()}.dart").writeAsString(nxParser.toDart(wrapperClassName,resourceName, customScript: customScript));
  }
}
