part of springbok_server;

class SpringbokCookie implements Cookie {
  final Cookie _cookie;
  var _data;
  
  SpringbokCookie(String name) : _cookie = new Cookie(name);
  
  SpringbokCookie.fromCookie(this._cookie) {
    if (_cookie.value == null || _cookie.value.isEmpty) {
      data = null;
    } else {
      _decryptValue();
    }
  }

  void _decryptValue() {
    print('Cookie: ${_cookie.name}, ${_cookie.value}');
    assert(CONFIG['cookiesKey'] != null);
    var decryptedvalue = _cookie.value;
    // TODO https://github.com/izaera/cipher/wiki/Using-block-ciphers, CONFIG['cookiesKey'];
    var jsonData = decryptedvalue.substring(40);
    if (sha256(decryptedvalue) != decryptedvalue.substring(0, 40)) {
      throw new Exception('CCookie : decrypted data does not match hash (name = ${_cookie.name})');
    }
    _data = JSON.decode(jsonData);
  }
  
  void encryptValue() {
    if (data == null || (data is String && (data as String).isEmpty)) {
      _cookie.value = '';
    } else {
      var jsonData = JSON.encode(data);
      var hash = sha256(jsonData);
      var encryptedValue = hash + jsonData; //TODO cipher
      _cookie.value = encryptedValue;
    }
  }
  
  @override
  String get domain => _cookie.domain;

  @override  
  void set domain(String _domain) {
    _cookie.domain = _domain;
  }

  @override
  DateTime get expires => _cookie.expires;

  @override
  void set expires(DateTime _expires) {
    _cookie.expires = _expires;
  }

  @override
  bool get httpOnly => _cookie.httpOnly;

  @override
  void set httpOnly(bool _httpOnly) {
    _cookie.httpOnly = _httpOnly;
  }

  @override
  int get maxAge => _cookie.maxAge;

  @override
  void set maxAge(int _maxAge) {
    _cookie.maxAge = _maxAge;
  }

  @override
  String get name => _cookie.name;

  @override
  void set name(String _name) {
    _cookie.name = _name;
  }

  @override
  String get path => _cookie.path;

  @override
  void set path(String _path) {
    _cookie.path = _path;
  }

  @override
  bool get secure => _cookie.secure;

  @override
  void set secure(bool _secure) {
    _cookie.secure = _secure;
  }

  @override
  String get value => throw new UnsupportedError('Please use data');

  @override
  void set value(String _value) {
    throw new UnsupportedError('Please use data');
  }
  
  @override
  get data => _data;

  @override
  void set data(data) {
    _data = data;
    encryptValue();
  }
}

class Cookies extends Object with ListMixin<SpringbokCookie> implements List<Cookie> {
  Cookies(List<Cookie> cookies) {
    for (Cookie cookie in cookies) {
      if (cookie is SpringbokCookie) {
        this.add(cookie);
      } else {
        this.add(new SpringbokCookie.fromCookie(cookie));
      }
    }
  }
  
  int length;

  SpringbokCookie operator [](int index) {
    this.elementAt(index);
  }

  void operator []=(int index, Cookie value) {
    this.insert(index, value);
  }

  
  SpringbokCookie byName(String name) {
    return firstWhere((Cookie cookie) => cookie.name == name);
  }
}