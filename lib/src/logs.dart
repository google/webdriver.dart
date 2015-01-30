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
}
class LogEntry {
  final String message;
  final int timestamp;
  final String level;

  const LogEntry(this.message, this.timestamp, this.level);

  LogEntry.fromMap(Map map)
      : this(map['message'], map['timestamp'], map['level']);
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