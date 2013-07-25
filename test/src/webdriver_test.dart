part of webdriver_test;


/**
 * These tests are not expected to be run as part of normal automated testing,
 * as they are slow and they have external dependencies.
 */
class WebDriverTest {
  main() {

    WebDriver driver;

    group('WebDriver', () {

      test('create default', () {
        WebDriver driver;
        WebDriver.createDriver()
            .then((_driver) {
              driver = _driver;
            })
            .then((_) => driver.get('http://www.google.com'))
            .then((_) => driver.findElement(new By.name('q')))
            .then((element) => element.name)
            .then((name) {
              expect(name, 'input');
              return driver.quit();
            }).then(expectAsync1((_) {}));
      });

      test('create chrome', () {
        WebDriver driver;
        WebDriver.createDriver(desiredCapabilities: Capabilities.chrome)
            .then((_driver) {
              driver = _driver;
            })
            .then((_) => driver.get('http://www.google.com'))
            .then((_) => driver.findElement(new By.name('q')))
            .then((element) => element.name)
            .then((name) {
              expect(name, 'input');
              return driver.quit();
            }).then(expectAsync1((_) {}));
      });

      test('create firefox', () {
        WebDriver driver;
        WebDriver.createDriver(desiredCapabilities: Capabilities.firefox)
            .then((_driver) {
              driver = _driver;
            })
            .then((_) => driver.get('http://www.google.com'))
            .then((_) => driver.findElement(new By.name('q')))
            .then((element) => element.name)
            .then((name) {
              expect(name, 'input');
              return driver.quit();
            }).then(expectAsync1((_) {}));
      });
    });
  }
}