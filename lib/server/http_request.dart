part of springbok_server;

class HttpRequest implements IoHttp.HttpRequest {
  final IoHttp.HttpRequest _httpRequest;
  
  @override
  final HttpResponse response;
  
  Route route;
  
  HttpRequest.fromIoHttpRequest(IoHttp.HttpRequest request)
      : this._httpRequest = request,
        this.response = new HttpResponse.fromIoHttpResponse(request.response)
        ;
  
  Cookies _cookies;

  Cookies get cookies {
    if (_cookies != null) return _cookies;
    return _cookies = new Cookies(_httpRequest.cookies);
  }

  @override
  Future<bool> any(bool test(List<int> element)) => _httpRequest.any(test);

  @override
  Stream<List<int>> asBroadcastStream({void onListen(StreamSubscription<List<int>> subscription), void onCancel(StreamSubscription<List<int>> subscription)})
    => _httpRequest.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  X509Certificate get certificate => _httpRequest.certificate;

  @override
  HttpConnectionInfo get connectionInfo => _httpRequest.connectionInfo;

  @override
  Future<bool> contains(Object needle) => _httpRequest.contains(needle);

  @override
  int get contentLength => _httpRequest.contentLength;

  @override
  Stream<List<int>> distinct([bool equals(List<int> previous, List<int> next)])
      => _httpRequest.distinct(equals);

  @override
  Future drain([futureValue]) => _httpRequest.drain(futureValue);

  @override
  Future<List<int>> elementAt(int index) => _httpRequest.elementAt(index);

  @override
  Future<bool> every(bool test(List<int> element)) => _httpRequest.every(test);

  @override
  Stream expand(Iterable convert(List<int> value)) => _httpRequest.expand(convert);

  @override
  Future<List<int>> get first => _httpRequest.first;

  @override
  Future firstWhere(bool test(List<int> element), {Object defaultValue()})
    => _httpRequest.firstWhere(test, defaultValue: defaultValue);

  @override
  Future fold(initialValue, combine(previous, List<int> element))
    => _httpRequest.fold(initialValue, combine);

  @override
  Future forEach(void action(List<int> element))
    => _httpRequest.forEach(action);

  @override
  Stream<List<int>> handleError(Function onError, {bool test(error)})
    => _httpRequest.handleError(onError, test: test);

  @override
  HttpHeaders get headers => _httpRequest.headers;

  @override
  bool get isBroadcast => _httpRequest.isBroadcast;

  @override
  Future<bool> get isEmpty => _httpRequest.isEmpty;

  @override
  Future<String> join([String separator = ""]) => _httpRequest.join(separator);

  @override
  Future<List<int>> get last => _httpRequest.last;

  @override
  Future lastWhere(bool test(List<int> element), {Object defaultValue()})
    => _httpRequest.lastWhere(test, defaultValue: defaultValue);

  @override
  Future<int> get length => _httpRequest.length;

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> event), {Function onError, void onDone(), bool cancelOnError})
    => _httpRequest.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream map(convert(List<int> event)) => _httpRequest.map(convert);

  @override
  String get method => _httpRequest.method;

  @override
  bool get persistentConnection => _httpRequest.persistentConnection;

  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) => _httpRequest.pipe(streamConsumer);

  @override
  String get protocolVersion => _httpRequest.protocolVersion;

  @override
  Future<List<int>> reduce(List<int> combine(List<int> previous, List<int> element))
    => _httpRequest.reduce(combine);

  @override
  HttpSession get session => _httpRequest.session;

  @override
  Future<List<int>> get single => _httpRequest.single;

  @override
  Future<List<int>> singleWhere(bool test(List<int> element))
    => _httpRequest.singleWhere(test);

  @override
  Stream<List<int>> skip(int count) => _httpRequest.skip(count);

  @override
  Stream<List<int>> skipWhile(bool test(List<int> element))
    => _httpRequest.skipWhile(test);

  @override
  Stream<List<int>> take(int count) => _httpRequest.take(count);

  @override
  Stream<List<int>> takeWhile(bool test(List<int> element))
    => _httpRequest.takeWhile(test);

  @override
  Future<List<List<int>>> toList() => _httpRequest.toList();

  @override
  Future<Set<List<int>>> toSet() => _httpRequest.toSet();

  @override
  Stream transform(StreamTransformer<List<int>, dynamic> streamTransformer)
    => _httpRequest.transform(streamTransformer);

  @override  
  Uri get uri => _httpRequest.uri;

  @override
  Stream<List<int>> where(bool test(List<int> event))
    => _httpRequest.where(test);
}