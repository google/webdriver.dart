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

library webdriver.support.forwarder;

import 'dart:async' show Future, Stream, StreamConsumer;
import 'dart:convert' show JSON, UTF8;
import 'dart:io' show Directory, File;

import 'package:path/path.dart' as path;
import 'package:shelf/shelf.dart' as shelf;
import 'package:webdriver/core.dart'
    show By, WebDriver, WebDriverException, WebElement;

/// Attribute on elements used to locate them on passed WebDriver commands.
const wdElementIdAttribute = 'wd-element-id';

/// [WebDriverForwarder] accepts [HttpRequest]s corresponding to a variation on
/// the WebDriver wire protocol and forwards them to a WebDriver instance.
///
/// The primary difference between this and the standard wire protocol is in
/// the use of WebElement ids. When you need to refer to an element in a request
/// (URI or JSON body), then you should add an 'wd-element-id' attribute to the
/// corresponding element with a unique identifier, and use that identifier as
/// the element id for that element. This class will then search for the
/// corresponding element and in the document and will substitute an actual
/// WebElement id for the given identifier in the request.
///
/// This forwarder supports two additional commands that control how it searches
/// for elements:
///   POST '/enabledeep': enables searching through all Shadow DOMs in the
///     document for the corresponding element (but will fail on browsers that
///     don't support the '/deep/' css selector combinator).
///   POST '/disabledeep': disables searching in Shadow DOMs of the document.
///
/// This forwarder also supports two additional commands for grabbing the
/// browser contents and saving it to the file system.
///   POST '/screenshot': takes a 'file' arg and will capture a screenshot
///     of the browser and save it to the specified file name in [outputDir].
///   POST '/source': takes a 'file' arg and will capture the current page's
///     source and save it to the specified file name in [outputDir].
///
/// Finally the forwarder support a command for switching to a specific
/// frame:
///   POST '/findframe/<id>': switches to  a frame that includes an element
///     with wd-element-id="frame-id" and innerText equal to id.
///     Only looks at the top-level context and any first-level iframes.
///     All iframes in the top-level context will be made visible.
///
/// See https://code.google.com/p/selenium/wiki/JsonWireProtocol for
/// documentation of other commands.
class WebDriverForwarder {
  /// [WebDriver] instance to forward commands to.
  final WebDriver driver;
  /// Path prefix that all forwarded commands will have. Should be relative.
  final Pattern prefix;
  /// Directory to save screenshots and page source to.
  final Directory outputDir;
  /// Search for elements in all shadow doms of the current document.
  bool useDeep;

  WebDriverForwarder(this.driver,
      {this.prefix: 'webdriver', Directory outputDir, this.useDeep: false})
      : this.outputDir = outputDir == null
          ? Directory.systemTemp.createTempSync()
          : outputDir;

  /// Forward [request] to [driver] and respond to the request with the returned
  /// value or any thrown exceptions.
  Future<shelf.Response> handler(shelf.Request request) async {
    try {
      if (!request.url.path.startsWith(prefix)) {
        return new shelf.Response.notFound(null);
      }

      var endpoint = request.url.path.replaceFirst(prefix, '');
      if (endpoint.startsWith('/')) {
        endpoint = endpoint.substring(1);
      }
      var params;
      if (request.method == 'POST') {
        String requestBody = await UTF8.decodeStream(request.read());
        if (requestBody != null && requestBody.isNotEmpty) {
          params = JSON.decode(requestBody);
        }
      }
      var value = await _forward(request.method, endpoint, params);
      return new shelf.Response.ok(JSON.encode({'status': 0, 'value': value}),
          headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache'
      });
    } on WebDriverException catch (e) {
      return new shelf.Response.internalServerError(
          body: JSON.encode(
              {'status': e.statusCode, 'value': {'message': e.message}}),
          headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache'
      });
    } catch (e) {
      return new shelf.Response.internalServerError(
          body: JSON.encode({'status': 13, 'value': {'message': e.toString()}}),
          headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-cache'
      });
    }
  }

  Future _forward(String method, String endpoint,
      [Map<String, dynamic> params]) async {
    List<String> endpointTokens = path.split(endpoint);
    if (endpointTokens.isEmpty) {
      endpointTokens = [''];
    }
    switch (endpointTokens[0]) {
      case 'enabledeep':
        // turn on Shadow DOM support, don't forward
        useDeep = true;
        return null;
      case 'disabledeep':
        // turn off Shadow DOM support, don't forward
        useDeep = false;
        return null;
      case 'screenshot':
        if (method == 'POST') {
          // take a screenshot and save to file system
          var file =
              new File(path.join(outputDir.path, params['file'])).openWrite();
          await driver.captureScreenshot().pipe(file as StreamConsumer<int>);
          return null;
        }
        break;
      case 'source':
        if (method == 'POST') {
          // grab page source and save to file system
          await new File(path.join(outputDir.path, params['file']))
              .writeAsString(await driver.pageSource);
          return null;
        }
        break;
      case 'findframe':
        await _findFrame(endpointTokens[1]);
        return null;
      case 'element':
        // process endpoints of the form /element/[id]/...
        if (endpointTokens.length >= 2) {
          endpointTokens[1] = await _findElement(endpointTokens[1]);
        }
        // process endpoint /element/[id]/equals/[id]
        if (endpointTokens.length == 4 && endpointTokens[2] == 'equals') {
          endpointTokens[3] = await _findElement(endpointTokens[3]);
        }
        break;
      case 'touch':
      case 'moveto':
        // several /touch/... endpoints and the /moveto endpoint have an
        // optional 'element' param with a WebElement id value
        if (params['element'] != null) {
          params = new Map.from(params);
          params['element'] = await _findElement(params['element']);
        }
        break;
      case 'execute':
      case 'execute_async':
        // /execute and /execute_async allow arbitrary JSON objects with
        // embedded WebElememt ids.
        params = await _deepCopy(params);
        break;
    }

    switch (method) {
      case 'GET':
        return await driver.getRequest(path.joinAll(endpointTokens));
      case 'DELETE':
        return await driver.deleteRequest(path.joinAll(endpointTokens));
      case 'POST':
        return await driver.postRequest(path.joinAll(endpointTokens), params);
      default:
        throw 'unsupported method $method';
    }
  }

  Future _findFrame(String id) async {
    await driver.switchTo.frame();
    if (await _isFrame(id)) {
      return;
    }
    await for (WebElement element
        in driver.findElements(const By.tagName('iframe'))) {
      if (!await element.displayed) {
        await driver.execute(
            'arguments[0].style.display = "block";', [element]);
      }
      await driver.switchTo.frame(element);
      if (await _isFrame(id)) {
        return;
      }
      await driver.switchTo.frame();
    }
    throw 'Frame $id not found';
  }

  Future<bool> _isFrame(String id) async {
    await for (WebElement element in _findElements('frame-id')) {
      if ((await element.attributes['innerText']).trim() == id) {
        return true;
      }
    }
    return false;
  }

  Future<String> _findElement(String id) async =>
      (await _findElements(id).toList()).single.id;

  Stream<WebElement> _findElements(String id) async* {
    var selector = "[$wdElementIdAttribute='$id']";
    if (useDeep) {
      selector = '* /deep/ $selector';
    }
    yield* driver.findElements(new By.cssSelector(selector));
  }

  dynamic _deepCopy(dynamic source) async {
    if (source is Map) {
      var copy = {};

      for (var key in source.keys) {
        var value = source[key];
        if (key == 'ELEMENT') {
          copy['ELEMENT'] = await _findElement(value);
        } else {
          copy[await _deepCopy(key)] = await _deepCopy(value);
        }
      }
      return copy;
    } else if (source is Iterable) {
      var copy = [];
      for (var value in source) {
        copy.add(await _deepCopy(value));
      }
      return copy;
    } else {
      return source;
    }
  }
}
