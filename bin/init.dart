

import 'dart:io';
import 'package:path/path.dart' as path;

main(List<String> args) async{

  var relativePath = path.relative("lib/src");
  var nxResDir = Directory(relativePath + "/nxres/strings");
  nxResDir.createSync(recursive: true);

}