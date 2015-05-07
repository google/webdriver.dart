// Copyright 2015 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library webdriver.io_test;

import 'dart:convert' show JSON;
import 'dart:io' show File, FileSystemEntity, Platform;

import 'package:path/path.dart' as path;
import 'package:webdriver/io.dart' show WebDriver, Capabilities, createDriver;

import 'test_util.dart' as test_util;

void config() {
  test_util.runningOnTravis = Platform.environment['TRAVIS'] == 'true';
  var config = _readConfig(new File('lib/test/configs/chrome_cfg.json'));

  test_util.createTestDriver = ({Map additionalCapabilities}) {
    Map capabilities = {};
    if (config.containsKey('desired')) {
      capabilities.addAll(config['desired']);
    }
    if (additionalCapabilities != null) {
      capabilities.addAll(additionalCapabilities);
    }
    var address = null;
    if (config.containsKey('address')) {
      address = Uri.parse(config['address']);
    }
    return createDriver(uri: address, desired: capabilities);
  };

  var testPagePath = path.join(path.current, 'test', 'test_page.html');
  testPagePath = path.absolute(testPagePath);
  if (!FileSystemEntity.isFileSync(testPagePath)) {
    throw new Exception('Could not find the test file at "$testPagePath".'
        ' Make sure you are running tests from the root of the project.');
  }
  test_util.testPagePath = path.toUri(testPagePath).toString();
}

Map<String, dynamic> _readConfig(File configFile) {
  Map config = JSON.decode(configFile.readAsStringSync());
  return _updateConfig(config);
}

_updateConfig(config) {
  if (config is String && config.startsWith(r'$')) {
    return Platform.environment[config.substring(1)];
  }
  if (config is Map) {
    var result = {};
    for (var key in config.keys) {
      var value = config[key];
      result[_updateConfig(key)] = _updateConfig(value);
    }
    return result;
  }
  if (config is Iterable) {
    var result = [];
    for (var value in config) {
      result.add(_updateConfig(value));
    }
    return result;
  }
  return config;
}