part of webdriver_test;

/**
 * Tests for switchTo.frame(). switchTo.window() and switchTo.alert are tested
 * in other classes.
 */
class TargetLocatorTest {
  main() {

    group('TargetLocator', () {

      WebDriver driver;
      WebElement frame;

      setUp(() {
        return WebDriver.createDriver(desiredCapabilities: Capabilities.chrome)
            .then((_driver) => driver = _driver)
            .then((_) => driver.get(testPagePath))
            .then((_) => driver.findElement(new By.name('frame')))
            .then((_e) => frame = _e);
      });

      tearDown(() => driver.quit());

      test('frame index', () {
        return driver.switchTo.frame(0)
            .then((_) => driver.pageSource)
            .then((source) {
              expect(source, contains('this is a frame'));
            });
      });

      test('frame name', () {
        return driver.switchTo.frame('frame')
            .then((_) => driver.pageSource)
            .then((source) {
              expect(source, contains('this is a frame'));
            });
      });

      test('frame element', () {
        return driver.switchTo.frame(frame)
            .then((_) => driver.pageSource)
            .then((source) {
              expect(source, contains('this is a frame'));
            });
      });

      test('root frame', () {
        return driver.switchTo.frame(frame)
            .then((_) => driver.switchTo.frame())
            .then((_) => driver.pageSource)
            .then((_) => driver.findElement(new By.tagName('button')));
      });
    });
  }
}
