

import 'dart:io';
import 'package:path/path.dart' as path;

main(List<String> args) async{

  var relativePath = path.relative("lib/src");
  var nxClassDir = Directory(relativePath + "/nxclasses");
  var nxResDir = Directory(relativePath + "/nxres");
  nxClassDir.createSync();
  nxResDir.createSync();

}