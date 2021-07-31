import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:nxpress/src/models/nxpress_wrapper.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/nxpress_core.dart';
import 'package:source_gen/source_gen.dart';
import 'package:path/path.dart' as path;

class NxpressGenerator extends GeneratorForAnnotation<NxpressWrapper> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generatWidgetSource(element, annotation, buildStep);
  }

  Future<String> _generatWidgetSource(Element element, ConstantReader annotation, BuildStep buildStep) async {
    var visitor = NxpressVisitor();
    element.visitChildren(visitor);

    if (element.name == null) throw Exception("Class name must be definded!");

    var resourceName = element.name ?? "";

    var source = annotation.read("source").stringValue;
    var className = annotation.read("generateClass").stringValue;
    var schema = annotation.peek("schema");

    if (schema == null) throw Exception("Please Provide a schema!");

    var requiredNodes = schema.peek("requiredNodes")?.listValue.map((e) => e.toStringValue()?.trim() ?? "").toList();
    var requiredKeys = schema.peek("requiredKeys")?.listValue.map((e) => e.toStringValue()?.trim() ?? "").toList();
    var onlyRequiredNodes = schema.peek("onlyRequiredNodes")?.boolValue ?? false;
    var optionalKeys = schema.peek("optionalKeys")?.listValue.map((e) => e.toStringValue()?.trim() ?? "").toList();

    var nxSchema = NxpressSchema(requiredKeys: requiredKeys ?? [], optionalKeys: optionalKeys ?? [], requiredNodes: requiredNodes ?? [], onlyRequiredNodes: onlyRequiredNodes);

    var relativePath = path.relative("lib/src/nxres/$source");
    var dir = Directory(relativePath);
    var files = dir.listSync();

    var contents = "";

    for (var fileEntity in files) {
      var file = File(fileEntity.path);
      contents += await file.readAsString();
    }

    print(contents);

    var nxparser = NxpressCore.parse(contents, nxSchema, resourceName, className);

    return nxparser.toDart();
  }
}

class NxpressVisitor extends SimpleElementVisitor {}
