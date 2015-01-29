library webdriver_test.options;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

void main() {
  group('Cookies', () {
    WebDriver driver;

    setUp(() async {
      driver = await WebDriver.createDriver(
          desiredCapabilities: Capabilities.chrome);
      await driver.get('http://www.google.com');
    });

    tearDown(() => driver.quit());

    test('add simple cookie', () async {
      await driver.cookies.add(new Cookie('mycookie', 'myvalue'));

      bool found = false;
      for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          expect(cookie.value, 'myvalue');
          break;
        }
      }
      expect(found, isTrue);
    });

    test('add complex cookie', () async {
      var date = new DateTime.utc(2020);
      await driver.cookies.add(new Cookie('mycookie', 'myvalue',
          path: '/', domain: '.google.com', secure: false, expiry: date));
      bool found = false;
      for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          expect(cookie.value, 'myvalue');
          expect(cookie.expiry, date);
          break;
        }
      }
      expect(found, isTrue);
    });

    test('delete cookie', () async {
      await driver.cookies.add(new Cookie('mycookie', 'myvalue'));
      await driver.cookies.delete('mycookie');
      bool found = false;
      for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          break;
        }
      }
      expect(found, isFalse);
    });

    test('delete all cookies', () async {
      await driver.cookies.deleteAll();
      expect(await driver.cookies.all.toList(), isEmpty);
    });
  });

  group('TimeOuts', () {
    WebDriver driver;

    setUp(() async {
      driver = await WebDriver.createDriver(
          desiredCapabilities: Capabilities.chrome);
    });

    tearDown(() => driver.quit());

    // TODO(DrMarcII): Figure out how to tell if timeouts are correctly set
    test('set all timeouts', () async {
      await driver.timeouts.setScriptTimeout(new Duration(seconds: 5));
      await driver.timeouts.setImplicitTimeout(new Duration(seconds: 1));
      await driver.timeouts.setPageLoadTimeout(new Duration(seconds: 10));
    });
  });
}
