library springbok_builder;

import 'package:springbok/compiler.dart';
import 'package:compiler/builder.dart' as CompilerBuilder;


Future build(List<String> args) {
  return CompilerBuilder.build(args);
}
