library webdriver_test_util;

import 'dart:io';
import 'package:path/path.dart' as pathos;
import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

final Matcher isWebDriverError = new isInstanceOf<WebDriverError>();
final Matcher isWebElement = new isInstanceOf<WebElement>();
final Matcher isSize = new isInstanceOf<Size>();
final Matcher isPoint = new isInstanceOf<Point>();

String get testPagePath {
  if(_testPagePath == null) {
    _testPagePath = _getTestPagePath();
  }
  return _testPagePath;
}

String _getTestPagePath() {
  var testPagePath = pathos.join(pathos.current, 'test', 'test_page.html');
  testPagePath = pathos.absolute(testPagePath);
  if(!FileSystemEntity.isFileSync(testPagePath)) {
    throw new Exception('Could not find the test file at "$testPagePath".'
        ' Make sure you are running tests from the root of the project.');
  }
  return pathos.toUri(testPagePath).toString();
}

String _testPagePath;
