part of webdriver;

class Cookies extends _WebDriverBase {

  Cookies._(prefix, commandProcessor)
      : super('$prefix/cookie', commandProcessor);

  /// Set a cookie.
  Future<Cookies> add(Cookie cookie) => _post('', { 'cookie': cookie })
      .then((_) => this);

  /// Delete the cookie with the given name.
  Future<Cookies> delete(String name) => _delete('$name').then((_) => this);

  /// Delete all cookies visible to the current page.
  Future<Cookies> deleteAll() => _delete('').then((_) => this);

  /// Retrieve all cookies visible to the current page.
  Future<List<Cookie>> get all =>
      _get('')
      .then((cookies) =>
          cookies.map((cookie) => new Cookie.fromJson(cookie)).toList());
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
      expiry = new DateTime
          .fromMillisecondsSinceEpoch(json['expiry']*1000, isUtc: true);
    }
    return new Cookie(
        json['name'],
        json['value'],
        path: json['path'],
        domain: json['domain'],
        secure: json['secure'],
        expiry: expiry);
  }

  Map<String, dynamic> toJson() {
    var json = {
        'name': name,
        'value': value
    };
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
}

class Timeouts extends _WebDriverBase {

  Timeouts._(prefix, commandProcessor)
      : super('$prefix/timeouts', commandProcessor);

  Future<Timeouts> _set(String type, Duration duration) =>
      _post('', { 'type' : type, 'ms': duration.inMilliseconds})
      .then((_) => this);

  /// Set the script timeout.
  Future<Timeouts> setScriptTimeout(Duration duration) =>
      _set('script', duration);

  /// Set the implicit timeout.
  Future<Timeouts> setImplicitTimeout(Duration duration) =>
      _set('implicit', duration);

  /// Set the page load timeout.
  Future<Timeouts> setPageLoadTimeout(Duration duration) =>
      _set('page load', duration);

  /// Set the async script timeout.
  Future<Timeouts> setAsyncScriptTimeout(Duration duration) =>
      _post('async_script', { 'ms': duration.inMilliseconds})
      .then((_) => this);

  /// Set the implicit wait timeout.
  Future<Timeouts> setImplicitWaitTimeout(Duration duration) =>
      _post('implicit_wait', { 'ms': duration.inMilliseconds})
      .then((_) => this);
}
