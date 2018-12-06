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

import 'dart:math';

import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/w3c/utils.dart';

class W3cWindowHandler extends WindowHandler {
  @override
  WebDriverRequest buildGetWindowsRequest() =>
      new WebDriverRequest.getRequest('window/handles');

  @override
  List<String> parseGetWindowsResponse(WebDriverResponse response) =>
      parseW3cResponse(response).cast<String>();

  @override
  WebDriverRequest buildGetActiveWindowRequest() =>
      new WebDriverRequest.getRequest('window');

  @override
  String parseGetActiveWindowResponse(WebDriverResponse response) =>
      parseW3cResponse(response);

  @override
  WebDriverRequest buildSetActiveRequest(String windowId) =>
      new WebDriverRequest.postRequest('window', {'handle': windowId});

  @override
  void parseSetActiveResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildLocationRequest() => buildRectRequest();

  @override
  Point<int> parseLocationResponse(WebDriverResponse response) =>
      parseRectResponse(response).topLeft;

  @override
  WebDriverRequest buildSizeRequest() => buildRectRequest();

  @override
  Rectangle<int> parseSizeResponse(WebDriverResponse response) {
    final rect = parseRectResponse(response);
    return new Rectangle(0, 0, rect.width, rect.height);
  }

  @override
  WebDriverRequest buildRectRequest() =>
      new WebDriverRequest.getRequest('window/rect');

  @override
  Rectangle<int> parseRectResponse(WebDriverResponse response) {
    final rect = parseW3cResponse(response);
    return new Rectangle(rect['x'].toInt(), rect['y'].toInt(),
        rect['width'].toInt(), rect['height'].toInt());
  }

  @override
  WebDriverRequest buildSetLocationRequest(Point<int> location) =>
      new WebDriverRequest.postRequest(
          'window/rect', {'x': location.x, 'y': location.y});

  @override
  void parseSetLocationResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildSetSizeRequest(Rectangle<int> size) =>
      new WebDriverRequest.postRequest(
          'window/rect', {'width': size.width, 'height': size.height});

  @override
  void parseSetSizeResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildSetRectRequest(Rectangle<int> rect) =>
      new WebDriverRequest.postRequest('window/rect', {
        'x': rect.left,
        'y': rect.top,
        'width': rect.width,
        'height': rect.height
      });

  @override
  void parseSetRectResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildMaximizeRequest() =>
      new WebDriverRequest.postRequest('window/maximize');

  @override
  void parseMaximizeResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildMinimizeRequest() =>
      new WebDriverRequest.postRequest('window/minimize');

  @override
  void parseMinimizeResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildCloseRequest() =>
      new WebDriverRequest.deleteRequest('window');

  @override
  void parseCloseResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildInnerSizeRequest() =>
      new WebDriverRequest.postRequest('execute/sync', {
        'script':
            'return { width: window.innerWidth, height: window.innerHeight };',
        'args': []
      });

  @override
  Rectangle<int> parseInnerSizeResponse(WebDriverResponse response) {
    final size = parseW3cResponse(response);
    return Rectangle(0, 0, size['width'], size['height']);
  }
}
