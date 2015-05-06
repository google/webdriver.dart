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
