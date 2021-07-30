import 'package:meta/meta_meta.dart';
import 'package:nxpress/src/models/nxpress_schema.dart';

@Target({TargetKind.classType})
class NxpressClass {
  final String? source;
  final String? className;
  final NxpressSchema? schema;

  const NxpressClass({this.source, this.className,this.schema});
}
