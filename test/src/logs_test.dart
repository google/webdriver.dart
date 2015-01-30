library webdriver_test.logs;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

void main() {
  group('Logs', () {
    WebDriver driver;
    
    setUp(() async {
      Map capabilities = Capabilities.chrome
          ..[Capabilities.LOGGING_PREFS] =
              {LogType.PERFORMANCE: LogLevel.INFO};
      driver = await WebDriver.createDriver(desiredCapabilities: capabilities);
      await driver.get('http://www.google.com');
    });

    tearDown(() => driver.quit());

    test('get logs', () async {
      List<LogEntry> logs = await driver.logs.get(LogType.PERFORMANCE).toList();
      expect(logs.length, greaterThan(0));
      logs.forEach((entry) {
        expect(entry.level, equals(LogLevel.INFO));
      });
    });
  });
}
