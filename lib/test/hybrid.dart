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

library webdriver.test.hybrid;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:webdriver/html.dart';

var _id;

Future<WebDriver> createDriver() async {
  //throw "${window.location}";
  var path = p.join('/', p.split(window.location.pathname)[1], 'webdriver/');
  WebDriver driver = await fromExistingSession('1',
      uri: new Uri.http(
          '${window.location.hostname}:${window.location.port}', path));
  if (_id == null) {
    _id = new Random().nextInt(1024).toString();
    var div = new Element.div()
      ..attributes['wd-element-id'] = 'frame-id'
      ..text = _id;

    document.body.append(div);
  }
  await driver.postRequest('findframe/$_id');
  return driver;
}
