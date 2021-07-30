import 'package:meta/meta_meta.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

@Target({TargetKind.classType})
class NxpressClass {
  /// [source] defines the directory under the nxres folder. Nxpress will load the nx files
  /// for this resource from the given directory.
  final String? source;

  /// [generateClass] defines the parent class which holds your generated resources as static variables
  /// ```dart
  /// class NxStrings {
  ///   static final node = NxString({"en":"hello world"})
  ///   static final node_2 = NxString({"en":"hello world"})
  /// }
  /// ```
  final String? generateClass;

  /// [schema] defines custom rules for your nx files
  final NxpressSchema? schema;

  const NxpressClass({this.source, this.generateClass, this.schema});
}
