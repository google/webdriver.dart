part of webdriver_test;

class AlertTest {
  main() {

    File file = new File('test_page.html');

    group('Alert', () {

      WebDriver driver;
      WebElement button;
      WebElement link;

      setUp(() {
        return WebDriver.createDriver()
            .then((_driver) => driver = _driver)
            .then((_) => driver.get('file://' + file.fullPathSync()))
            .then((_) => driver.findElement(new By.tagName('button')))
            .then((_element) => button = _element)
            .then((_) => driver.findElement(new By.id('settable')))
            .then((_element) => link = _element);
      });

      tearDown(() => driver.quit());

      test('no alert', () {
        return driver.switchTo.alert.catchError((error) {
          expect(error, new isInstanceOf<WebDriverError>());
        });
      });

      test('text', () {
        return button.click().then((_) => driver.switchTo.alert)
            .then((alert) {
              expect(alert.text, 'button clicked');
              return alert.dismiss();
            });
      });

      test('accept', () {
        return button.click().then((_) => driver.switchTo.alert)
            .then((alert) => alert.accept())
            .then((_) => link.text)
            .then((text) {
              expect(text, startsWith('accepted'));
            });
      });

      test('dismiss', () {
        return button.click().then((_) => driver.switchTo.alert)
            .then((alert) => alert.dismiss())
            .then((_) => link.text)
            .then((text) {
              expect(text, startsWith('dismissed'));
            });
      });

      test('sendKeys', () {
        Alert alert;
        return button.click().then((_) => driver.switchTo.alert)
            .then((_alert) => alert = _alert)
            .then((_) => alert.sendKeys('some keys'))
            .then((_) => alert.accept())
            .then((_) => link.text)
            .then((text) {
              expect(text, endsWith('some keys'));
            });
      });
    });
  }
}