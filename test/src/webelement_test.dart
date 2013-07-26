part of webdriver_test;

class WebElementTest {
  main() {

    File file = new File('test_page.html');

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
        button.click()
          .then((_) => driver.switchTo.alert)
          .then((alert) =>  alert.accept())
          .then(expectAsync1((_) { }));
      });

      test('submit', () {
        form.submit()
          .then((_) => driver.switchTo.alert)
          .then((alert) {
            expect(alert.text, 'form submitted');
            return alert.accept();
          })
          .then(expectAsync1((_) { }));
      });

      test('sendKeys', () {
        textInput.sendKeys('some keys')
          .then((_) => textInput.attributes['value'])
          .then(expectAsync1((value) {
            expect(value, 'some keys');
          }));
      });

      test('clear', () {
        textInput.sendKeys('some keys')
          .then((_) => textInput.clear())
          .then((_) => textInput.attributes['value'])
          .then(expectAsync1((value) {
            expect(value, '');
          }));
      });

      test('enabled', () {
        table.enabled.then(expectAsync1((enabled) {
          expect(enabled, isTrue);
        }));
        button.enabled.then(expectAsync1((enabled) {
          expect(enabled, isTrue);
        }));
        form.enabled.then(expectAsync1((enabled) {
          expect(enabled, isTrue);
        }));
        textInput.enabled.then(expectAsync1((enabled) {
          expect(enabled, isTrue);
        }));
        checkbox.enabled.then(expectAsync1((enabled) {
          expect(enabled, isTrue);
        }));
        disabled.enabled.then(expectAsync1((enabled) {
          expect(enabled, isFalse);
        }));
      });

      test('displayed', () {
        table.displayed.then(expectAsync1((displayed) {
          expect(displayed, isTrue);
        }));
        button.displayed.then(expectAsync1((displayed) {
          expect(displayed, isTrue);
        }));
        form.displayed.then(expectAsync1((displayed) {
          expect(displayed, isTrue);
        }));
        textInput.displayed.then(expectAsync1((displayed) {
          expect(displayed, isTrue);
        }));
        checkbox.displayed.then(expectAsync1((displayed) {
          expect(displayed, isTrue);
        }));
        disabled.displayed.then(expectAsync1((displayed) {
          expect(displayed, isTrue);
        }));
        invisible.displayed.then(expectAsync1((displayed) {
          expect(displayed, isFalse);
        }));
      });

      test('location', () {
        table.location.then(expectAsync1((location) {
          expect(location, new isInstanceOf<Point>());
          expect(location.x, isNonNegative);
          expect(location.y, isNonNegative);
        }));
        invisible.location.then(expectAsync1((location) {
          expect(location, new isInstanceOf<Point>());
          expect(location.x, 0);
          expect(location.y, 0);
        }));
      });

      test('size', () {
        table.size.then(expectAsync1((size) {
          expect(size, new isInstanceOf<Size>());
          expect(size.width, isNonNegative);
          expect(size.height, isNonNegative);
        }));
        invisible.size.then(expectAsync1((size) {
          expect(size, new isInstanceOf<Size>());
          // TODO(DrMarcII): I thought these should be 0
          expect(size.width, isNonNegative);
          expect(size.height, isNonNegative);
        }));
      });

      test('name', () {
        table.name.then(expectAsync1((name) {
          expect(name, 'table');
        }));
        button.name.then(expectAsync1((name) {
          expect(name, 'button');
        }));
        form.name.then(expectAsync1((name) {
          expect(name, 'form');
        }));
        textInput.name.then(expectAsync1((name) {
          expect(name, 'input');
        }));
      });

      test('text', () {
        table.text.then(expectAsync1((text) {
          expect(text, 'r1c1 r1c2\nr2c1 r2c2');
        }));
        button.text.then(expectAsync1((text) {
          expect(text, 'button');
        }));
        invisible.text.then(expectAsync1((text) {
          expect(text, '');
        }));
      });

      test('findElement -- success', () {
        table.findElement(new By.tagName('tr'))
            .then(expectAsync1((element) {
              expect(element, new isInstanceOf<WebElement>());
            }));
      });

      test('findElement -- failure', () {
        button.findElement(new By.tagName('tr'))
            .catchError(expectAsync1((error) {
              expect(error, new isInstanceOf<WebDriverError>());
            }));
      });

      test('findElements -- 1 found', () {
        form.findElements(new By.cssSelector('input[type=text]'))
            .then(expectAsync1((elements) {
              expect(elements.length, 1);
              expect(elements, everyElement(new isInstanceOf<WebElement>()));
            }));
      });

      test('findElements -- 4 found', () {
        table.findElements(new By.tagName('td'))
            .then(expectAsync1((elements) {
              expect(elements.length, 4);
              expect(elements, everyElement(new isInstanceOf<WebElement>()));
            }));
      });

      test('findElements -- 0 found', () {
        form.findElements(new By.tagName('td'))
            .then(expectAsync1((elements) {
              expect(elements.length, 0);
            }));
      });

      test('attributes', () {
        table.attributes['id'].then(expectAsync1((attr) {
          expect(attr, 'table1');
        }));
        table.attributes['non-standard'].then(expectAsync1((attr) {
          expect(attr, 'a non standard attr');
        }));
        table.attributes['disabled'].then(expectAsync1((attr) {
          expect(attr, isNull);
        }));
        disabled.attributes['disabled'].then(expectAsync1((attr) {
          expect(attr, 'true');
        }));
      });

      test('cssProperties', () {
        invisible.cssProperties['display'].then(expectAsync1((prop) {
          expect(prop, 'none');
        }));
        invisible.cssProperties['background-color'].then(expectAsync1((prop) {
          expect(prop, 'rgba(255, 0, 0, 1)');
        }));
        invisible.cssProperties['direction'].then(expectAsync1((prop) {
          expect(prop, 'ltr');
        }));
      });

      test('equals', () {
        invisible.equals(disabled).then(expectAsync1((equal) {
          expect(equal, isFalse);
        }));
        driver.findElement(new By.cssSelector('table'))
          .then((element) => element.equals(table))
          .then(expectAsync1((equals) {
            expect(equals, isTrue);
          }));
      });
    });
  }
}