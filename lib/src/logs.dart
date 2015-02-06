// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of webdriver;

class Logs extends _WebDriverBase {
  Logs._(driver) : super(driver, 'log');

  Stream<LogEntry> get(String logType) {
    var controller = new StreamController<LogEntry>();

    () async {
      var entries = await _post('', {'type': logType});
      for (var entry in entries) {
        controller.add(new LogEntry.fromMap(entry));
      }
      await controller.close();
    }();

    return controller.stream;
  }

  @override
  String toString() => '$driver.logs';

  @override
  int get hashCode => driver.hashCode;

  @override
  bool operator ==(other) => other is Logs && other.driver == driver;
}

class LogEntry {
  final String message;
  final DateTime timestamp;
  final String level;

  const LogEntry(this.message, this.timestamp, this.level);

  LogEntry.fromMap(Map map) : this(map['message'],
          new DateTime.fromMillisecondsSinceEpoch(map['timestamp'].toInt(),
              isUtc: true), map['level']);

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
