import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:nxpress/src/models/nxpress_class.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';
import 'package:nxpress/src/nxpress_core.dart';
import 'package:source_gen/source_gen.dart';
import 'package:path/path.dart' as path;

class NxpressGenerator extends GeneratorForAnnotation<NxpressClass> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generatWidgetSource(element, annotation, buildStep);
  }

  Future<String> _generatWidgetSource(Element element, ConstantReader annotation, BuildStep buildStep) async {
    var visitor = NxpressVisitor();
    element.visitChildren(visitor);

    var resourceName = element.name ?? "UnknownResource";

    var source = annotation.read("source").stringValue;
    var schema = annotation.peek("schema");

    var className = schema?.peek("className")?.stringValue ?? "";
    var requiredKeys = schema?.peek("requiredKeys")?.listValue.map((e) => e.toStringValue()?.trim() ?? "").toList();
    print(requiredKeys);
    var optionalKeys = schema?.peek("optionalKeys")?.listValue.map((e) => e.toStringValue()?.trim() ?? "").toList();

    var nxSchema = NxpressSchema(requiredKeys: requiredKeys, optionalKeys: optionalKeys ?? [], className: className);

    var relativePath = path.relative("lib/src/nxres/$source");
    var dir = Directory(relativePath);
    var files = dir.listSync();

    var contents = "";

    for (var fileEntity in files) {
      var file = File(fileEntity.path);
      contents += await file.readAsString();
    }

    // if(!dir.existsSync()) {
    //   dir.createSync();
    //   return;
    // }

    var nxparser = NxpressCore.parse(contents, nxSchema, resourceName);

    return nxparser.toDart();
    return "";
  }
}

class NxpressVisitor extends SimpleElementVisitor {}
