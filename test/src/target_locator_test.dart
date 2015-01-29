library webdriver_test.target_locator;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';
import '../test_util.dart';

/**
 * Tests for switchTo.frame(). switchTo.window() and switchTo.alert are tested
 * in other classes.
 */
void main() {
  group('TargetLocator', () {
    WebDriver driver;
    WebElement frame;

    setUp(() async {
      driver = await WebDriver.createDriver(
          desiredCapabilities: Capabilities.chrome);
      await driver.get(testPagePath);
      frame = await driver.findElement(new By.name('frame'));
    });

    tearDown(() => driver.quit());

    test('frame index', () async {
      await driver.switchTo.frame(0);
      expect(await driver.pageSource, contains('this is a frame'));
    });

    test('frame name', () async {
      await driver.switchTo.frame('frame');
      expect(await driver.pageSource, contains('this is a frame'));
    });

    test('frame element', () async {
      await driver.switchTo.frame(frame);
      expect(await driver.pageSource, contains('this is a frame'));
    });

    test('root frame', () async {
      await driver.switchTo.frame(frame);
      await driver.switchTo.frame();
      await driver.findElement(new By.tagName('button'));
    });
  });
}
