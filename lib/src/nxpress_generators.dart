import 'package:build/build.dart';
import 'package:nxpress/src/generators/nxpress_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder nxpressGenerator(BuilderOptions options) => SharedPartBuilder([NxpressGenerator()], "nx");
