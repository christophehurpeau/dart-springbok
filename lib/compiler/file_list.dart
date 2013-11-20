part of springbok_compiler;

class SpringbokFileList extends PreprocessorFileList {
  final Map<String, Function> map = {
    
  };
  
  SpringbokFileList(Compiler compiler) : super(compiler);
  
  @override
  FileCompilable createFileByExtension(File file, String filePath, String extension){
    if(! map.containsKey(extension))
      return super.createFileByExtension(file, filePath, extension);
    return map[extension](this, file, filePath);
  }
}