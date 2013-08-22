library webdriver_test_util;

import 'dart:io' as io;
import 'package:path/path.dart' as pathos;

String _testPagePath;

String get testPagePath {
  if(_testPagePath == null) {
    _testPagePath = _getTestPagePath();
  }
  return _testPagePath;
}

String _getTestPagePath() {
  var scriptPath = (new io.Options()).script;
  var scriptDir = pathos.dirname(scriptPath);
  var testPagePath = pathos.join(scriptDir, 'test_page.html');
  testPagePath = pathos.absolute(testPagePath);
  return pathos.toUri(testPagePath).toString();
}
