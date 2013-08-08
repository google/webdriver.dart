part of webdriver_test;

class WebDriverTest {
  main() {

    WebDriver driver;
    io.File file = new io.File('test_page.html');

    group('WebDriver', () {
      group('create', () {
        test('default', () {
          WebDriver driver;
          return WebDriver.createDriver()
              .then((_driver) {
                driver = _driver;
              })
              .then((_) => driver.get('http://www.google.com'))
              .then((_) => driver.findElement(new By.name('q')))
              .then((element) => element.name)
              .then((name) {
                expect(name, 'input');
                return driver.quit();
              });
        });

        test('chrome', () {
          WebDriver driver;
          return WebDriver
              .createDriver(desiredCapabilities: Capabilities.chrome)
              .then((_driver) {
                driver = _driver;
              })
              .then((_) => driver.get('http://www.google.com'))
              .then((_) => driver.findElement(new By.name('q')))
              .then((element) => element.name)
              .then((name) {
                expect(name, 'input');
                return driver.quit();
              });
        });

        test('firefox', () {
          WebDriver driver;
          return WebDriver
              .createDriver(desiredCapabilities: Capabilities.firefox)
              .then((_driver) {
                driver = _driver;
              })
              .then((_) => driver.get('http://www.google.com'))
              .then((_) => driver.findElement(new By.name('q')))
              .then((element) => element.name)
              .then((name) {
                expect(name, 'input');
                return driver.quit();
              });
        });
      });

      group('methods', () {

        setUp(() {
          return WebDriver
              .createDriver(desiredCapabilities: Capabilities.firefox)
              .then((_driver) => driver = _driver)
              .then((_) => driver.get('file://' + file.fullPathSync()));
        });

        tearDown(() => driver.quit());

        test('get', () {
          return driver.get('http://www.google.com')
              .then((_) => driver.findElement(new By.name('q')))
              .then((_) => driver.get('http://www.yahoo.com'))
              .then((_) => driver.findElement(new By.name('p')));
        });

        test('currentUrl', () {
          return driver.currentUrl.then((url) {
            expect(url, startsWith('file:'));
            expect(url, endsWith('test_page.html'));
            return driver.get('http://www.google.com');
          })
          .then((_) => driver.currentUrl)
          .then((url) {
            expect(url, contains('www.google.com'));
          });
        });

        test('findElement -- success', () {
          driver.findElement(new By.tagName('tr'))
              .then(expectAsync1((element) {
                expect(element, isWebElement);
              }));
        });

        test('findElement -- failure', () {
          return driver.findElement(new By.id('non-existent-id'))
              .catchError((error) {
                expect(error, isWebDriverError);
              });
        });

        test('findElements -- 1 found', () {
          return driver.findElements(new By.cssSelector('input[type=text]'))
              .then((elements) {
                expect(elements, hasLength(1));
                expect(elements, everyElement(isWebElement));
              });
        });

        test('findElements -- 4 found', () {
          return driver.findElements(new By.tagName('td'))
              .then((elements) {
                expect(elements, hasLength(4));
                expect(elements, everyElement(isWebElement));
              });
        });

        test('findElements -- 0 found', () {
          return driver.findElements(new By.id('non-existent-id'))
              .then((elements) {
                expect(elements, isEmpty);
              });
        });

        test('pageSource', () {
          return driver.pageSource.then((source) {
            expect(source, contains('<title>test_page</title>'));
          });
        });

        test('close/windowHandles', () {
          int numHandles;
          return driver.windowHandles
              .then((handles) => numHandles = handles.length)
              .then((_) => driver.findElement(new By.partialLinkText('Open copy')))
              .then((element) => element.click())
              .then((_) => driver.close())
              .then((_) => driver.windowHandles)
              .then((handles) {
                expect(handles, hasLength(numHandles));
              });
        });

        test('windowHandle', () {
          String origHandle;
          String newHandle;
          return driver.windowHandle
              .then((_handle) => origHandle = _handle)
              .then((_) => driver.findElement(new By.partialLinkText('Open copy')))
              .then((element) => element.click())
              .then((_) => driver.windowHandles)
              .then((handles) {
                for (String aHandle in handles) {
                  if (aHandle != origHandle) {
                    newHandle = aHandle;
                    return driver.switchTo.window(aHandle);
                  }
                }
              })
              .then((_) => driver.windowHandle)
              .then((finalHandle) {
                expect(finalHandle, newHandle);
              });
        });

        // TODO(DrMarcII): Figure out why this doesn't pass
//        test('activeElement', () {
//          return driver.activeElement
//              .then((element) {
//                expect(element, isNull);
//                return driver
//                    .findElement(new By.cssSelector('input[type=text]'));
//              })
//              .then((element) => element.click())
//              .then((_) => driver.activeElement)
//              .then((element) => element.name)
//              .then((name) {
//                expect(name, 'input');
//              });
//        });

        test('windows', () {
          return driver.windows.then((windows) {
            expect(windows, hasLength(isPositive));
            expect(windows, everyElement(new isInstanceOf<Window>()));
          });
        });

        test('execute', () {
          WebElement button;
          String script = '''
              arguments[1].textContent = arguments[0];
              return arguments[1];''';
          return driver.findElement(new By.tagName('button'))
              .then((_e) => button = _e)
              .then((_) => driver.execute(script, ['new text', button]))
              .then((WebElement e) {
                expect(e.text, completion('new text'));
              });
        });

        test('executeAsync', () {
          WebElement button;
          String script = '''
              arguments[1].textContent = arguments[0];
              arguments[2](arguments[1]);''';
          return driver.findElement(new By.tagName('button'))
              .then((_e) => button = _e)
              .then((_) => driver.executeAsync(script, ['new text', button]))
              .then((WebElement e) {
                expect(e.text, completion('new text'));
              });
        });

        test('captureScreenshot', () {
          return driver.captureScreenshot()
              .then((screenshot) {
                expect(screenshot, hasLength(isPositive));
                expect(screenshot, everyElement(new isInstanceOf<int>()));
              });
        });
      });
    });
  }
}
