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

import '../../common/geometry.dart';
import '../../common/request.dart';
import '../../common/webdriver_handler.dart';
import 'utils.dart';

class JsonWireWindowHandler extends WindowHandler {
  @override
  WebDriverRequest buildGetWindowsRequest() =>
      WebDriverRequest.getRequest('window_handles');

  @override
  List<String> parseGetWindowsResponse(WebDriverResponse response) =>
      (parseJsonWireResponse(response) as List).cast<String>();

  @override
  WebDriverRequest buildGetActiveWindowRequest() =>
      WebDriverRequest.getRequest('window_handle');

  @override
  String parseGetActiveWindowResponse(WebDriverResponse response) =>
      parseJsonWireResponse(response) as String;

  @override
  WebDriverRequest buildSetActiveRequest(String windowId) =>
      WebDriverRequest.postRequest('window', {'name': windowId});

  @override
  void parseSetActiveResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildLocationRequest() =>
      WebDriverRequest.getRequest('window/current/position');

  @override
  Position parseLocationResponse(WebDriverResponse response) {
    final point = parseJsonWireResponse(response) as Map<String, Object?>;
    return Position(
      x: (point['x'] as num).toInt(),
      y: (point['y'] as num).toInt(),
    );
  }

  @override
  WebDriverRequest buildSizeRequest() =>
      WebDriverRequest.getRequest('window/current/size');

  @override
  Size parseSizeResponse(WebDriverResponse response) {
    final size = parseJsonWireResponse(response) as Map<String, Object?>;
    return Size(
      width: (size['width'] as num).toInt(),
      height: (size['height'] as num).toInt(),
    );
  }

  @override
  WebDriverRequest buildRectRequest() {
    throw UnsupportedError('Get Window Rect is not supported in JsonWire.');
  }

  @override
  Rect parseRectResponse(WebDriverResponse response) {
    throw UnsupportedError('Get Window Rect is not supported in JsonWire.');
  }

  @override
  WebDriverRequest buildSetLocationRequest(Position location) =>
      WebDriverRequest.postRequest(
          'window/current/position', {'x': location.x, 'y': location.y});

  @override
  void parseSetLocationResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildSetSizeRequest(Size size) =>
      WebDriverRequest.postRequest(
          'window/current/size', {'width': size.width, 'height': size.height});

  @override
  void parseSetSizeResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildSetRectRequest(Rect rect) {
    throw UnsupportedError('Set Window Rect is not supported in JsonWire.');
  }

  @override
  void parseSetRectResponse(WebDriverResponse response) {
    throw UnsupportedError('Set Window Rect is not supported in JsonWire.');
  }

  @override
  WebDriverRequest buildMaximizeRequest() =>
      WebDriverRequest.postRequest('window/current/maximize');

  @override
  void parseMaximizeResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildMinimizeRequest() => throw 'Unsupported in JsonWire';

  @override
  void parseMinimizeResponse(WebDriverResponse response) =>
      throw 'Unsupported in JsonWire';

  @override
  WebDriverRequest buildCloseRequest() =>
      WebDriverRequest.deleteRequest('window');

  @override
  void parseCloseResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildInnerSizeRequest() =>
      WebDriverRequest.postRequest('execute', {
        'script':
            'return { width: window.innerWidth, height: window.innerHeight };',
        'args': <Object>[]
      });

  @override
  Size parseInnerSizeResponse(WebDriverResponse response) {
    final size = parseJsonWireResponse(response) as Map<String, Object?>;
    return Size(
      width: (size['width'] as num).toInt(),
      height: (size['height'] as num).toInt(),
    );
  }
}
