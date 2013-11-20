import 'package:compiler/compiler.dart';
import 'package:compiler/builder.dart' as CompilerBuilder;
import 'package:springbok/compiler.dart';

build(List<String> args){
  CompilerBuilder.build(args, (Compiler compiler) => new SpringbokFileList(compiler));
}
