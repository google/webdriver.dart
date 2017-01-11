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

You can run the tests either with bazel (only supported on Linux).

```shell

bazel test ...
```
