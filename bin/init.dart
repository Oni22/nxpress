

import 'dart:io';
import 'package:path/path.dart' as path;

main(List<String> args) async{

  var relativePath = path.relative("lib/src");
  var nxResNamespacesDir = Directory(relativePath + "/nxres/resources");
  var nxResCustomDir = Directory(relativePath + "/nxres/custom");
  nxResNamespacesDir.createSync(recursive: true);
  nxResCustomDir.createSync(recursive: true);
  File(relativePath + "/nxres/custom/schemas.nx").writeAsString("[]");
  var nxResDir = Directory(relativePath + "/nxres/resources/strings");
  nxResDir.createSync(recursive: true);

}