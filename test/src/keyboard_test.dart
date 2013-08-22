part of webdriver_test;

class KeyboardTest {
  main() {

    group('Keyboard', () {

      WebDriver driver;
      WebElement textInput;

      setUp(() {
        return WebDriver.createDriver(desiredCapabilities: Capabilities.firefox)
            .then((_driver) => driver = _driver)
            .then((_) => driver.get(_testPagePath))
            .then((_) =>
                driver.findElement(new By.cssSelector('input[type=text]')))
            .then((_element) => textInput = _element)
            .then((_) => driver.mouse.moveTo(element: textInput).click());
      });

      tearDown(() => driver.quit());

      test('sendKeys -- once', () {
        return driver.keyboard.sendKeys('abcdef')
            .then((_) => textInput.attributes['value'])
            .then((value) {
              expect(value, 'abcdef');
            });
      });

      test('sendKeys -- twice', () {
        return driver.keyboard.sendKeys('abc').sendKeys('def')
            .then((_) => textInput.attributes['value'])
            .then((value) {
              expect(value, 'abcdef');
            });
      });

      test('sendKeys -- list', () {
        return driver.keyboard.sendKeys(['a', 'b', 'c', 'd', 'e', 'f'])
            .then((_) => textInput.attributes['value'])
            .then((value) {
              expect(value, 'abcdef');
            });
      });

      // doesn't work with chromedriver
      // https://code.google.com/p/chromedriver/issues/detail?id=443
      test('sendKeys -- with tab', () {
        return driver.keyboard.sendKeys(['abc', Keys.TAB, 'def'])
            .then((_) => textInput.attributes['value'])
            .then((value) {
              expect(value, 'abc');
            });
      });
    });
  }
}
