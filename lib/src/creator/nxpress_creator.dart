import 'dart:io';

import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/nxpress_core.dart';
import 'package:path/path.dart' as path;

class NxpressCreator {
  final String namespace;
  final NxpressSchema schema;
  final String resourceName;

  NxpressCreator({required this.namespace, required this.schema, required this.resourceName});

  Future<void> build() async {
    var relativePath = path.relative("lib/src/nxres/$namespace");

    final fileEntities = Directory(relativePath).listSync();
    fileEntities.removeWhere((element) => path.extension(element.path) != ".nx");
    var contents = "";

    for (var fileEntity in fileEntities) {
      final file = File(fileEntity.path);
      contents += await file.readAsString();
    }

    final wrapperClassName = resourceName + "s";
    final nxParser = NxpressCore.parse(contents, schema, resourceName, wrapperClassName);

    await File(relativePath + "/${wrapperClassName.toLowerCase()}.dart").writeAsString(nxParser.toDart());
  }
}
