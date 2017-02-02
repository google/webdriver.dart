// Copyright 2017 Google Inc. All Rights Reserved.
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

library io_test_util;

import 'dart:async' show Future;
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:webdriver/core.dart' show WebDriver;
import 'package:webdriver/io.dart' as wdio;

export 'test_util.dart' show isWebElement, isRectangle, isPoint;

Future<WebDriver> createTestDriver(
    {Map<String, dynamic> additionalCapabilities}) {
  var address = Platform.environment['WEB_TEST_WEBDRIVER_SERVER'];
  if (!address.endsWith('/')) {
    address += '/';
  }
  var uri = Uri.parse(address);
  return wdio.createDriver(uri: uri, desired: additionalCapabilities);
}

String _testPagePath;
HttpServer _server;

Future<String> get testPagePath async {
  if (_testPagePath == null) {
    _server = await HttpServer.bind(InternetAddress.ANY_IP_V4, 0);
    _server.listen((request) {
      if (request.method == 'GET') {
        File file = new File(runfile(path.joinAll(request.uri.pathSegments)));
        if (!file.existsSync()) {
          request.response
            ..statusCode = HttpStatus.NOT_FOUND
            ..close();
          return;
        }
        request.response
          ..statusCode = HttpStatus.OK
          ..headers.set('Content-type', 'text/html');
        file.openRead().pipe(request.response);
        return;
      }
      request.response
        ..statusCode = HttpStatus.NOT_FOUND
        ..close();
    });
    _testPagePath =
        new Uri.http('localhost:${_server.port}', '/test/test_page.html');
  }

  return _testPagePath;
}

String runfile(String p) => path.absolute(path.join(
    Platform.environment['TEST_SRCDIR'],
    'com_github_google_webdriver_dart',
    p));

Future tearDown() async {
  if (_server != null) {
    await _server.close(force: true);
  }
  _server = null;
}
