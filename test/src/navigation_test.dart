library webdriver_test.navigation;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';
import '../test_util.dart';

void main() {

  group('Navigation', () {

    WebDriver driver;

    setUp(() {
      return WebDriver.createDriver(desiredCapabilities: Capabilities.chrome)
          .then((_driver) => driver = _driver)
          .then((_) => driver.get('http://www.google.com'));
    });

    tearDown(() => driver.quit());

    test('forward/back', () {
      return driver.get('http://www.yahoo.com')
          .then((_) => driver.navigate.back())
          .then((_) => driver.title)
          .then((title) {
            expect(title, contains('Google'));
            return driver.navigate.forward();
          })
          .then((_) => driver.title)
          .then((title) {
            expect(title, contains('Yahoo'));
          });
    });

    test('refresh', () {
      var element;
      return driver.findElement(new By.name('q'))
          .then((_e) => element = _e)
          .then((_) => driver.navigate.refresh())
          .then((_) => element.name)
          .catchError((error) {
            // search should be stale after refresh
              expect(error, isWebDriverError);
            });
    });
  });
}
