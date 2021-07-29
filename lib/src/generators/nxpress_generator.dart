import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:nxpress/src/models/nxpress_class.dart';
import 'package:source_gen/source_gen.dart';

class NxpressGenerator extends GeneratorForAnnotation<NxpressClass> {
  
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print(element);
    return _generatWidgetSource(element);
  }

  String _generatWidgetSource(Element element) {
    var visitor = NxpressVisitor();
    element.visitChildren(visitor);
    return "*/ HALLO */";
  }
}

class NxpressVisitor extends SimpleElementVisitor {}
