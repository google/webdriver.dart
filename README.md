# webdriver

[![Build Status](https://travis-ci.org/google/webdriver.dart.svg?branch=master)](https://travis-ci.org/google/webdriver.dart)
[![pub package](https://img.shields.io/pub/v/webdriver.svg)](https://pub.dartlang.org/packages/webdriver)

Provides WebDriver bindings for Dart. These use the WebDriver JSON interface,
and as such, require the use of the WebDriver remote server.

## Installing

1.  Depend on it

    Add this to your package's pubspec.yaml file:

    ```YAML
    dependencies:
      webdriver: any
    ```

    If your package is an application package you should use any as the version
    constraint.

2.  Install it

    If you're using the Dart Editor, choose:

    ```
    Menu > Tools > Pub Install
    ```

    Or if you want to install from the command line, run:

    ```
    $ pub install
    ```

3.  Import it

    Now in your Dart code, you can use:

    ```Dart
    import 'package:webdriver/io.dart';

    WebDriver driver = createDriver(...);
    ```

## Testing

Unfortunately using bazel with Dart libraries and Dart WebDriver is not yet
supported. We hope to add this at some point, but for now pub still works. 

As a consequence, running tests is a bit more complicated than we'd like:

1) Launch a WebDriver binar(ies).
 
   First, bring up chromedriver / geckodriver. Other conforming WebDriver
   binaries should work as well, but we test against these:
   
   ```
   chromedriver --port=4444 --url-base=wd/hub --verbose
   geckodriver --port=4445
   ```
   
   ChromeDriver is used to test our JSON wire spec implementation, and
   geckodriver is used to test our W3C spec implementation.
   
   Synchronous tests are labeled as Chrome/Firefox. All async tests run
   exclusively against Chrome (as async, like ChromeDriver supports only the
   old JSON wire spec).

2) Run a test. All files suffixed with '_test.dart' are tests.

   ```
   pub run test/path/to/test.dart -r expanded -p vm
   ```
   
   Or to run *all* tests:
   
   ```
   pub run test -r expanded -p vm
   ```
   
   You should probably go get a coffee or something, this is gonna take awhile.
  

