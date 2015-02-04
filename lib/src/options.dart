part of webdriver;

class Cookies extends _WebDriverBase {
  Cookies._(driver) : super(driver, 'cookie');

  /// Set a cookie.
  Future add(Cookie cookie) async {
    await _post('', {'cookie': cookie});
  }

  /// Delete the cookie with the given [name].
  Future delete(String name) async {
    await _delete('$name');
  }

  /// Delete all cookies visible to the current page.
  Future deleteAll() async {
    await _delete('');
  }

  /// Retrieve all cookies visible to the current page.
  Stream<Cookie> get all {
    var controller = new StreamController<Cookie>();

    () async {
      var cookies = await _get('');
      int i = 0;
      for (var cookie in cookies) {
        controller.add(new Cookie.fromJson(cookie));
        i++;
      }
      await controller.close();
    }();

    return controller.stream;
  }
// TODO(DrMarcII): switch to this when async* is supported
//  async* {
//    var cookies = await _get('');
//    for (var cookie in cookies) {
//      yield new Cookie.fromJson(cookie);
//    }
//  }

  @override
  String toString() => '$driver.cookies';

  @override
  int get hashCode => driver.hashCode;

  @override
  bool operator ==(other) => other is Cookies && other.driver == driver;
}

class Cookie {
  /// The name of the cookie.
  final String name;
  /// The cookie value.
  final String value;
  /// (Optional) The cookie path.
  final String path;
  /// (Optional) The domain the cookie is visible to.
  final String domain;
  /// (Optional) Whether the cookie is a secure cookie.
  final bool secure;
  /// (Optional) When the cookie expires.
  final DateTime expiry;

  const Cookie(this.name, this.value,
      {this.path, this.domain, this.secure, this.expiry});

  factory Cookie.fromJson(Map<String, dynamic> json) {
    var expiry;
    if (json['expiry'] is num) {
      expiry = new DateTime.fromMillisecondsSinceEpoch(
          json['expiry'].toInt() * 1000, isUtc: true);
    }
    return new Cookie(json['name'], json['value'],
        path: json['path'],
        domain: json['domain'],
        secure: json['secure'],
        expiry: expiry);
  }

  Map<String, dynamic> toJson() {
    var json = {'name': name, 'value': value};
    if (path is String) {
      json['path'] = path;
    }
    if (domain is String) {
      json['domain'] = domain;
    }
    if (secure is bool) {
      json['secure'] = secure;
    }
    if (expiry is DateTime) {
      json['expiry'] = (expiry.millisecondsSinceEpoch / 1000).ceil();
    }
    return json;
  }

  @override
  String toString() => 'Cookie${toJson()}';
}

class Timeouts extends _WebDriverBase {
  Timeouts._(driver) : super(driver, 'timeouts');

  Future _set(String type, Duration duration) async {
    await _post('', {'type': type, 'ms': duration.inMilliseconds});
  }

  /// Set the script timeout.
  Future setScriptTimeout(Duration duration) => _set('script', duration);

  /// Set the implicit timeout.
  Future setImplicitTimeout(Duration duration) => _set('implicit', duration);

  /// Set the page load timeout.
  Future setPageLoadTimeout(Duration duration) => _set('page load', duration);

  @override
  String toString() => '$driver.timeouts';

  @override
  int get hashCode => driver.hashCode;

  @override
  bool operator ==(other) => other is Timeouts && other.driver == driver;
}
