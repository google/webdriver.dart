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
  static const String BROWSER = 'browser';
  static const String CLIENT = 'client';
  static const String DRIVER = 'driver';
  static const String PERFORMANCE = 'performance';
  static const String PROFILER = 'profiler';
  static const String SERVER = 'server';
}

class LogLevel {
  static const String OFF = 'OFF';
  static const String SEVERE = 'SEVERE';
  static const String WARNING = 'WARNING';
  static const String INFO = 'INFO';
  static const String DEBUG = 'DEBUG';
  static const String ALL = 'ALL';
}
