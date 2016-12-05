import 'package:webdriver/io.dart';

void main() async {
  Uri uri = new Uri.http('127.0.0.1:4444', '/');
  var caps = Capabilities.firefox;
  caps['marionette'] = true;
  caps['binary'] = '/usr/bin/firefox';

  try {
    WebDriver driver = await createDriver(uri: uri, desired: caps);
    print(driver.capabilities);
    driver.quit();
  } catch (e) {
    print(e);
  }
}
