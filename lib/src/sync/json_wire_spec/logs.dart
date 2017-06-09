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

class Logs {
  final WebDriver _driver;
  final Resolver _resolver;

  Logs(this._driver) : _resolver = new Resolver(_driver, 'log');

  List<LogEntry> get(String logType) {
    final entries = _resolver.post('', {'type': logType}) as List<Map>;
    return entries.map((e) => new LogEntry.fromMap(e)).toList();
  }

  @override
  String toString() => '$_driver.logs';

  @override
  int get hashCode => _driver.hashCode;

  @override
  bool operator ==(other) => other is Logs && other._driver == _driver;
}

class LogEntry {
  final String message;
  final DateTime timestamp;
  final String level;

  const LogEntry(this.message, this.timestamp, this.level);

  LogEntry.fromMap(Map map)
      : this(
            map['message'],
            new DateTime.fromMillisecondsSinceEpoch(map['timestamp'].toInt(),
                isUtc: true),
            map['level']);

  @override
  String toString() => '$level[$timestamp]: $message';
}

class LogType {
  static const String browser = 'browser';
  static const String client = 'client';
  static const String driver = 'driver';
  static const String performance = 'performance';
  static const String profiler = 'profiler';
  static const String server = 'server';
}

class LogLevel {
  static const String off = 'OFF';
  static const String severe = 'SEVERE';
  static const String warning = 'WARNING';
  static const String info = 'INFO';
  static const String debug = 'DEBUG';
  static const String all = 'ALL';
}
