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
        driver.switchTo.alert.catchError(expectAsync1((error) {
          expect(error, new isInstanceOf<WebDriverError>());
        }));
      });

      test('text', () {
        button.click().then((_) => driver.switchTo.alert)
            .then((alert) {
              expect(alert.text, 'button clicked');
              return alert.dismiss();
            })
            .then(expectAsync1((_) { }));
      });

      test('accept', () {
        button.click().then((_) => driver.switchTo.alert)
            .then((alert) => alert.accept())
            .then((_) => link.text)
            .then(expectAsync1((text) {
              expect(text, startsWith('accepted'));
            }));
      });

      test('dismiss', () {
        button.click().then((_) => driver.switchTo.alert)
            .then((alert) => alert.dismiss())
            .then((_) => link.text)
            .then(expectAsync1((text) {
              expect(text, startsWith('dismissed'));
            }));
      });

      test('sendKeys', () {
        Alert alert;
        button.click().then((_) => driver.switchTo.alert)
            .then((_alert) => alert = _alert)
            .then((_) => alert.sendKeys('some keys'))
            .then((_) => alert.accept())
            .then((_) => link.text)
            .then(expectAsync1((text) {
              expect(text, endsWith('some keys'));
            }));
      });
    });
  }
}