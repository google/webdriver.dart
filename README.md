[![CI](https://github.com/google/webdriver.dart/actions/workflows/ci.yaml/badge.svg)](https://github.com/google/webdriver.dart/actions/workflows/ci.yaml)
[![pub package](https://img.shields.io/pub/v/webdriver.svg)](https://pub.dartlang.org/packages/webdriver)
[![package publisher](https://img.shields.io/pub/publisher/webdriver.svg)](https://pub.dev/packages/webdriver/publisher)

Provides WebDriver bindings for Dart. These use the WebDriver JSON interface,
and as such, require the use of the WebDriver remote server.

In your Dart code, you can use:

```dart
import 'package:webdriver/io.dart';

WebDriver driver = createDriver(...);
```

This will use by default the asynchronous, JSON wire spec implementation. You
now can also use a synchronous version of WebDriver:

```dart
import 'package:webdriver/sync_io.dart';

final driver = createDriver(...);
```

This version of WebDriver supports both the JSON wire spec and W3C spec,
allowing use with modern versions of Firefox. This defaults to the JSON wire
spec, but can also be configured to use the W3C spec or even to try and
automatically infer the spec during session creation:

```dart
final w3cDriver = createDriver(spec: WebDriverSpec.W3c);  // Use W3C spec.

final anyDriver = createDriver(spec: WebDriverSpec.Auto); // Infer spec.
```

## Testing

Unfortunately using bazel with Dart libraries and Dart WebDriver is not yet
supported. We hope to add this at some point, but for now pub still works.

As a consequence, running tests is a bit more complicated than we'd like:

1. Launch a WebDriver binar(ies).

   First, bring up chromedriver / geckodriver. Other conforming WebDriver
   binaries should work as well, but we test against these:

   ```
   chromedriver --port=4444 --url-base=wd/hub --verbose
   geckodriver --port=4445
   ```

   ChromeDriver is used to test our JSON wire spec implementation, and
   geckodriver is used to test our W3C spec implementation.

   Synchronous tests are labeled as Chrome/Firefox. All async tests run
   exclusively against Chrome (as async, like ChromeDriver supports only the old
   JSON wire spec).

2. Run a test. All files suffixed with `_test.dart` are tests.

   ```
   dart test test/path/to/the_test.dart -r expanded -p vm
   ```

   Or to run _all_ tests:

   ```
   dart test -r expanded -p vm
   ```

   You should probably go get a coffee or something, this is gonna take a while.
