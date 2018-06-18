// Copyright 2017 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import '../common.dart';
import '../web_driver.dart';

/// Interacts with browser's cookies.
class Cookies {
  final WebDriver _driver;
  final Resolver _resolver;

  Cookies(this._driver) : _resolver = new Resolver(_driver, 'cookie');

  /// Set a cookie.
  void add(Cookie cookie) {
    _resolver.post('', {'cookie': cookie});
  }

  /// Delete the cookie with the given [name].
  void delete(String name) {
    _resolver.delete('$name');
  }

  /// Delete all cookies visible to the current page.
  void deleteAll() {
    _resolver.delete('');
  }

  /// Retrieve all cookies visible to the current page.
  List<Cookie> get all {
    final cookies = _resolver.get('') as List<Map<String, dynamic>>;
    return cookies.map((c) => new Cookie.fromJson(c)).toList();
  }

  @override
  String toString() => '$_driver.cookies';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) => other is Cookies && other._driver == _driver;
}

/// Browser cookie.
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

  Cookie(this.name, this.value,
      {this.path, this.domain, this.secure, this.expiry});

  factory Cookie.fromJson(Map<String, dynamic> json) {
    DateTime expiry;
    if (json['expiry'] is num) {
      expiry = new DateTime.fromMillisecondsSinceEpoch(
          json['expiry'].toInt() * 1000,
          isUtc: true);
    }
    return new Cookie(json['name'] as String, json['value'] as String,
        path: json['path'] as String,
        domain: json['domain'] as String,
        secure: json['secure'] as bool,
        expiry: expiry);
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'name': name, 'value': value};
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
