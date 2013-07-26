part of webdriver_test;

class WebDriverTest {
  main() {

    WebDriver driver;
    File file = new File('test_page.html');

    group('WebDriver', () {
      group('create', () {
        test('default', () {
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

        test('chrome', () {
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

        test('firefox', () {
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

      group('methods', () {

        setUp(() {
          return WebDriver.createDriver(desiredCapabilities: Capabilities.firefox)
              .then((_driver) => driver = _driver)
              .then((_) => driver.get('file://' + file.fullPathSync()));
        });

        tearDown(() => driver.quit());

        test('get', () {
          driver.get('http://www.google.com')
              .then((_) => driver.findElement(new By.name('q')))
              .then((_) => driver.get('http://www.yahoo.com'))
              .then((_) => driver.findElement(new By.name('p')))
              .then(expectAsync1((_) { }));
        });

        test('currentUrl', () {
          driver.currentUrl.then((url) {
            expect(url, startsWith('file:'));
            expect(url, endsWith('test_page.html'));
            return driver.get('http://www.google.com');
          })
          .then((_) => driver.currentUrl)
          .then(expectAsync1((url) {
            expect(url, contains('www.google.com'));
          }));
        });

        test('findElement -- success', () {
          driver.findElement(new By.tagName('tr'))
              .then(expectAsync1((element) {
                expect(element, new isInstanceOf<WebElement>());
              }));
        });

        test('findElement -- failure', () {
          driver.findElement(new By.id('non-existent-id'))
              .catchError(expectAsync1((error) {
                expect(error, new isInstanceOf<WebDriverError>());
              }));
        });

        test('findElements -- 1 found', () {
          driver.findElements(new By.cssSelector('input[type=text]'))
              .then(expectAsync1((elements) {
                expect(elements.length, 1);
                expect(elements, everyElement(new isInstanceOf<WebElement>()));
              }));
        });

        test('findElements -- 4 found', () {
          driver.findElements(new By.tagName('td'))
              .then(expectAsync1((elements) {
                expect(elements.length, 4);
                expect(elements, everyElement(new isInstanceOf<WebElement>()));
              }));
        });

        test('findElements -- 0 found', () {
          driver.findElements(new By.id('non-existent-id'))
              .then(expectAsync1((elements) {
                expect(elements.length, 0);
              }));
        });

        test('pageSource', () {
          driver.pageSource.then(expectAsync1((source) {
            expect(source, contains('<title>test_page</title>'));
          }));
        });

        test('close/windowHandles', () {
          int numHandles;
          driver.windowHandles
              .then((handles) => numHandles = handles.length)
              .then((_) => driver.findElement(new By.partialLinkText('Open copy')))
              .then((element) => element.click())
              .then((_) => driver.close())
              .then((_) => driver.windowHandles)
              .then(expectAsync1((handles) {
                expect(handles, hasLength(numHandles));
              }));
        });

        test('windowHandle', () {
          String origHandle;
          String newHandle;
          driver.windowHandle
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
              .then(expectAsync1((finalHandle) {
                expect(finalHandle, newHandle);
              }));
        });

        // TODO(DrMarcII): Figure out why this doesn't pass
//        test('activeElement', () {
//          driver.activeElement
//              .then((element) {
//                expect(element, isNull);
//                return driver
//                    .findElement(new By.cssSelector('input[type=text]'));
//              })
//              .then((element) => element.click())
//              .then((_) => driver.activeElement)
//              .then((element) => element.name)
//              .then(expectAsync1((name) {
//                expect(name, 'input');
//              }));
//        });

        test('windows', () {
          driver.windows.then(expectAsync1((windows) {
            expect(windows, hasLength(isPositive));
            expect(windows, everyElement(new isInstanceOf<Window>()));
          }));
        });

        test('captureScreenshot', () {
          driver.captureScreenshot()
              .then(expectAsync1((screenshot) {
                expect(screenshot, hasLength(isPositive));
                expect(screenshot, everyElement(new isInstanceOf<int>()));
              }));
        });
      });
    });
  }
}