class LogEntry {
  final String message;
  final DateTime timestamp;
  final String level;

  const LogEntry(this.message, this.timestamp, this.level);

  LogEntry.fromMap(Map map)
      : this(
            map['message'],
            DateTime.fromMillisecondsSinceEpoch(map['timestamp'].toInt(),
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
