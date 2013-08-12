part of webdriver_test;

class OptionsTest {
  main() {

    group('Cookies', () {

      WebDriver driver;

      setUp(() {
        return WebDriver.createDriver(desiredCapabilities: Capabilities.chrome)
            .then((_driver) => driver = _driver)
            .then((_) => driver.get('http://www.google.com'));
      });

      tearDown(() => driver.quit());

      test('add simple cookie', () {
        return driver.cookies.add(new Cookie('mycookie', 'myvalue'))
            .then((_) => driver.cookies.all)
            .then((cookies) {
              bool found = false;
              for (var cookie in cookies) {
                if (cookie.name == 'mycookie') {
                  found = true;
                  expect(cookie.value, 'myvalue');
                }
              }
              expect(found, isTrue);
            });
      });

      test('add complex cookie', () {
        var date = new DateTime.utc(2014);
        return driver.cookies
            .add(new Cookie(
                'mycookie',
                'myvalue',
                path: '/',
                domain: '.google.com',
                secure: false,
                expiry: date))
            .then((_) => driver.cookies.all)
            .then((cookies) {
              bool found = false;
              for (var cookie in cookies) {
                if (cookie.name == 'mycookie') {
                  found = true;
                  expect(cookie.value, 'myvalue');
                  expect(cookie.expiry, date);
                }
              }
              expect(found, isTrue);
            });
      });

      test('delete cookie', () {
        return driver.cookies.add(new Cookie('mycookie', 'myvalue'))
            .then((_) => driver.cookies.delete('mycookie'))
            .then((_) => driver.cookies.all)
            .then((cookies) {
              bool found = false;
              for (var cookie in cookies) {
                if (cookie.name == 'mycookie') {
                  found = true;
                }
              }
              expect(found, isFalse);
            });
      });

      test('delete all cookies', () {
        return driver.cookies.deleteAll()
            .then((_) => driver.cookies.all)
            .then((cookies) {
              expect(cookies, isEmpty);
            });
      });
    });

    group('TimeOuts', () {
      WebDriver driver;

      setUp(() {
        return WebDriver.createDriver()
            .then((_driver) => driver = _driver);
      });

      tearDown(() => driver.quit());

      // TODO(DrMarcII): Figure out how to tell if timeouts are correctly set
      test('set all timeouts', () {
        return driver.timeouts.setScriptTimeout(new Duration(seconds: 5))
            .then((_) => driver.timeouts
                .setImplicitTimeout(new Duration(seconds: 1)))
            .then((_) => driver.timeouts
                .setPageLoadTimeout(new Duration(seconds: 10)))
            .then((_) => driver.timeouts
                .setAsyncScriptTimeout(new Duration(seconds: 7)))
            .then((_) => driver.timeouts
                .setImplicitWaitTimeout(new Duration(seconds: 2)));
      });
    });
  }
}
