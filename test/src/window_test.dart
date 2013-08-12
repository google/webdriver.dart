part of webdriver_test;

class WindowTest {
  main() {

    io.File file = new io.File('test_page.html');

    group('Window', () {

      WebDriver driver;

      setUp(() {
        return WebDriver.createDriver(desiredCapabilities: Capabilities.chrome)
            .then((_driver) => driver = _driver);
      });

      tearDown(() => driver.quit());

      test('size', () {
        return driver.window.setSize(new Size(400, 600))
            .then((_) => driver.window.size)
            .then((size) {
              expect(size, isSize);
              // TODO(DrMarcII): Switch to hasProperty matchers
              expect(size.height, 400);
              expect(size.width, 600);
            });
      });

      test('location', () {
        return driver.window.setLocation(new Point(10, 20))
            .then((_) => driver.window.location)
            .then((point) {
              expect(point, isPoint);
              // TODO(DrMarcII): Switch to hasProperty matchers
              expect(point.x, 10);
              expect(point.y, 20);
            });
      });

      // fails in some cases with multiple monitors
      test('maximize', () {
        return driver.window.maximize()
            .then((_) => driver.window.location)
              .then((point) {
                expect(point, isPoint);
                // TODO(DrMarcII): Switch to hasProperty matchers
                expect(point.x, 0);
                expect(point.y, 0);
              });
      });
    });
  }
}
