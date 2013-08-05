part of webdriver_test;

class WebElementTest {
  main() {

    io.File file = new io.File('test_page.html');

    group('WebElement', () {

      WebDriver driver;
      WebElement table;
      WebElement button;
      WebElement form;
      WebElement textInput;
      WebElement checkbox;
      WebElement disabled;
      WebElement invisible;

      setUp(() {
        return WebDriver.createDriver()
            .then((_driver) => driver = _driver)
            .then((_) => driver.get('file://' + file.fullPathSync()))
            .then((_) => driver.findElement(new By.tagName('table')))
            .then((_element) => table = _element)
            .then((_) => driver.findElement(new By.tagName('button')))
            .then((_element) => button = _element)
            .then((_) => driver.findElement(new By.tagName('form')))
            .then((_element) => form = _element)
            .then((_) =>
                driver.findElement(new By.cssSelector('input[type=text]')))
            .then((_element) => textInput = _element)
            .then((_) =>
                driver.findElement(new By.cssSelector('input[type=checkbox]')))
            .then((_element) => checkbox = _element)
            .then((_) =>
                driver.findElement(new By.cssSelector('input[type=password]')))
            .then((_element) => disabled = _element)
            .then((_) => driver.findElement(new By.tagName('div')))
            .then((_element) => invisible = _element);
      });

      tearDown(() => driver.quit());

      test('click', () {
        return button.click()
          .then((_) => driver.switchTo.alert)
          .then((alert) =>  alert.accept());
      });

      test('submit', () {
        return form.submit()
          .then((_) => driver.switchTo.alert)
          .then((alert) {
            // TODO(DrMarcII): Switch to hasProperty matchers
            expect(alert.text, 'form submitted');
            return alert.accept();
          });
      });

      test('sendKeys', () {
        return textInput.sendKeys('some keys')
          .then((_) => textInput.attributes['value'])
          .then((value) {
            expect(value, 'some keys');
          });
      });

      test('clear', () {
        return textInput.sendKeys('some keys')
          .then((_) => textInput.clear())
          .then((_) => textInput.attributes['value'])
          .then((value) {
            expect(value, '');
          });
      });

      test('enabled', () {
        expect(table.enabled, completion(isTrue));
        expect(button.enabled, completion(isTrue));
        expect(form.enabled, completion(isTrue));
        expect(textInput.enabled, completion(isTrue));
        expect(checkbox.enabled, completion(isTrue));
        expect(disabled.enabled, completion(isFalse));
      });

      test('displayed', () {
        expect(table.displayed, completion(isTrue));
        expect(button.displayed, completion(isTrue));
        expect(form.displayed, completion(isTrue));
        expect(textInput.displayed, completion(isTrue));
        expect(checkbox.displayed, completion(isTrue));
        expect(disabled.displayed, completion(isTrue));
        expect(invisible.displayed, completion(isFalse));
      });

      test('location -- table', () {
        return table.location.then((location) {
          expect(location, isPoint);
          // TODO(DrMarcII): Switch to hasProperty matchers
          expect(location.x, isNonNegative);
          expect(location.y, isNonNegative);
        });
      });

      test('location -- invisible', () {
        return invisible.location.then((location) {
          expect(location, isPoint);
          // TODO(DrMarcII): Switch to hasProperty matchers
          expect(location.x, 0);
          expect(location.y, 0);
        });
      });

      test('size -- table', () {
        return table.size.then((size) {
          expect(size, isSize);
          // TODO(DrMarcII): Switch to hasProperty matchers
          expect(size.width, isNonNegative);
          expect(size.height, isNonNegative);
        });
      });

      test('size -- invisible', () {
        return invisible.size.then((size) {
          expect(size, isSize);
          // TODO(DrMarcII): I thought these should be 0
          // TODO(DrMarcII): Switch to hasProperty matchers
          expect(size.width, isNonNegative);
          expect(size.height, isNonNegative);
        });
      });

      test('name', () {
        expect(table.name, completion('table'));
        expect(button.name, completion('button'));
        expect(form.name, completion('form'));
        expect(textInput.name, completion('input'));
      });

      test('text', () {
        expect(table.text, completion('r1c1 r1c2\nr2c1 r2c2'));
        expect(button.text, completion('button'));
        expect(invisible.text, completion(''));
      });

      test('findElement -- success', () {
        return table.findElement(new By.tagName('tr'))
            .then((element) {
              expect(element, isWebElement);
            });
      });

      test('findElement -- failure', () {
        return button.findElement(new By.tagName('tr'))
            .catchError((error) {
              expect(error, isWebDriverError);
            });
      });

      test('findElements -- 1 found', () {
        return form.findElements(new By.cssSelector('input[type=text]'))
            .then((elements) {
              expect(elements, hasLength(1));
              expect(elements, everyElement(isWebElement));
            });
      });

      test('findElements -- 4 found', () {
        return table.findElements(new By.tagName('td'))
            .then((elements) {
              expect(elements, hasLength(4));
              expect(elements, everyElement(isWebElement));
            });
      });

      test('findElements -- 0 found', () {
        return form.findElements(new By.tagName('td'))
            .then((elements) {
              expect(elements, isEmpty);
            });
      });

      test('attributes', () {
        expect(table.attributes['id'], completion('table1'));
        expect(table.attributes['non-standard'],
            completion('a non standard attr'));
        expect(table.attributes['disabled'], completion(isNull));
        expect(disabled.attributes['disabled'], completion('true'));
      });

      test('cssProperties', () {
        expect(invisible.cssProperties['display'], completion('none'));
        expect(invisible.cssProperties['background-color'],
            completion('rgba(255, 0, 0, 1)'));
        expect(invisible.cssProperties['direction'], completion('ltr'));
      });

      test('equals', () {
        expect(invisible.equals(disabled), completion(isFalse));
        return driver.findElement(new By.cssSelector('table'))
          .then((element) {
            expect(element.equals(table), completion(isTrue));
          });
      });
    });
  }
}
