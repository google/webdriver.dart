library webdriver_test.window;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';
import '../test_util.dart';

void main() {
  solo_group('Window', () {
    WebDriver driver;

    setUp(() async {
      driver = await WebDriver.createDriver(
          desiredCapabilities: Capabilities.chrome);
    });

    tearDown(() => driver.quit());

    test('size', () async {
      var window = await driver.window;
      await window.setSize(new Size(400, 600));
      var size = await window.size;
      expect(size, isSize);
      expect(size.height, 400);
      expect(size.width, 600);
    });

    test('location', () async {
      var window = await driver.window;

      await window.setLocation(new Point(10, 20));
      var point = await window.location;
      expect(point, isPoint);
      expect(point.x, 10);
      expect(point.y, 20);
    });

    // fails in some cases with multiple monitors
    test('maximize', () async {
      var window = await driver.window;
      await window.maximize();
      var point = await window.location;
      expect(point, isPoint);
      expect(point.x, 0);
      expect(point.y, 0);
    });
  });
}
