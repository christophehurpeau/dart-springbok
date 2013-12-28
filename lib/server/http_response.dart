part of springbok_server;

class HttpResponse implements IoHttp.HttpResponse {
  final IoHttp.HttpResponse _httpResponse;

  HttpResponse.fromIoHttpResponse(IoHttp.HttpResponse response)
      : this._httpResponse = response
        ;

  // TODO : status, message, details, responses html/json/xml...
  Future sendSimpleResponse({ int status: HttpStatus.NOT_FOUND, String message: 'Not Found' }){
    _httpResponse.statusCode = status;
    if (message != null) {
      _httpResponse.headers.add(HttpHeaders.CONTENT_TYPE, 'text/plain');
      _httpResponse.write(message);
    }
    return _httpResponse.close();
  }
  
  
  @override
  void add(List<int> data) => _httpResponse.add(data);

  @override
  void addError(error, [StackTrace stackTrace]) => _httpResponse.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _httpResponse.addStream(stream);

  @override
  Future close() => _httpResponse.close();

  @override
  HttpConnectionInfo get connectionInfo => _httpResponse.connectionInfo;

  @override
  void set contentLength(int _contentLength) {
    _httpResponse.contentLength = _contentLength;
  }

  @override
  int get contentLength => _httpResponse.contentLength;

  @override
  List<Cookie> get cookies => _httpResponse.cookies;

  @override
  void set deadline(Duration _deadline) {
    _httpResponse.deadline = _deadline;
  }

  @override
  Duration get deadline => _httpResponse.deadline;

  @override
  Future<Socket> detachSocket() => _httpResponse.detachSocket();

  @override
  Future get done => _httpResponse.done;

  @override
  void set encoding(Encoding _encoding) {
    _httpResponse.encoding = _encoding;
  }

  @override
  Encoding get encoding => _httpResponse.encoding;

  @override
  Future flush() => _httpResponse.flush();

  @override
  HttpHeaders get headers => _httpResponse.headers;

  @override
  bool get persistentConnection => _httpResponse.persistentConnection;

  @override
  void set persistentConnection(bool _persistentConnection) {
    _httpResponse.persistentConnection = _persistentConnection;
  }

  @override
  String get reasonPhrase => _httpResponse.reasonPhrase;

  @override
  void set reasonPhrase(String _reasonPhrase) {
    _httpResponse.reasonPhrase = _reasonPhrase;
  }

  @override
  Future redirect(Uri location, {int status: HttpStatus.MOVED_TEMPORARILY})
    => _httpResponse.redirect(location, status: status);

  @override
  int get statusCode => _httpResponse.statusCode;

  @override
  void set statusCode(int _statusCode) {
    _httpResponse.statusCode = _statusCode;
  }

  @override
  void write(Object obj) {
    _httpResponse.write(obj);
  }

  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    _httpResponse.writeAll(objects, separator);
  }

  @override
  void writeCharCode(int charCode) {
    _httpResponse.writeCharCode(charCode);
  }

  @override
  void writeln([Object obj = ""]) {
    _httpResponse.writeln(obj);
  }
}