library webdriver_test.navigation;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

void main() {
  group('Navigation', () {
    WebDriver driver;

    setUp(() async {
      driver = await WebDriver.createDriver(
          desiredCapabilities: Capabilities.chrome);
      await driver.get('http://www.google.com/ncr');
    });

    tearDown(() => driver.quit());

    test('forward/back', () async {
      await driver.get('http://www.yahoo.com');
      await driver.navigate.back();
      await waitFor(() => driver.title, matcher: contains('Google'));
      await driver.navigate.forward();
      await waitFor(() => driver.title, matcher: contains('Yahoo'));
    });

    test('refresh', () async {
      var element = await driver.findElement(new By.name('q'));
      await driver.navigate.refresh();
      try {
        await element.name;
        throw 'Expected SERE';
      } on StaleElementReferenceException {}
    });
  });
}
