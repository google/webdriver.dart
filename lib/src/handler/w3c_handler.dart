import 'dart:convert';

import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/w3c/alert.dart';
import 'package:webdriver/src/handler/w3c/cookies.dart';
import 'package:webdriver/src/handler/w3c/core.dart';
import 'package:webdriver/src/handler/w3c/element.dart';
import 'package:webdriver/src/handler/w3c/element_finder.dart';
import 'package:webdriver/src/handler/w3c/frame.dart';
import 'package:webdriver/src/handler/w3c/keyboard.dart';
import 'package:webdriver/src/handler/w3c/mouse.dart';
import 'package:webdriver/src/handler/w3c/navigation.dart';
import 'package:webdriver/src/handler/w3c/session.dart';
import 'package:webdriver/src/handler/w3c/timeouts.dart';
import 'package:webdriver/src/handler/w3c/utils.dart';
import 'package:webdriver/src/handler/w3c/window.dart';

class W3cWebDriverHandler extends WebDriverHandler {
  @override
  final SessionHandler session = new W3cSessionHandler();

  @override
  final CoreHandler core = new W3cCoreHandler();

  @override
  final KeyboardHandler keyboard = new W3cKeyboardHandler();

  @override
  final MouseHandler mouse = new W3cMouseHandler();

  @override
  final ElementFinder elementFinder = new W3cElementFinder();

  @override
  final ElementHandler element = new W3cElementHandler();

  @override
  final AlertHandler alert = new W3cAlertHandler();

  @override
  final NavigationHandler navigation = new W3cNavigationHandler();

  @override
  final WindowHandler window = new W3cWindowHandler();

  @override
  final FrameHandler frame = new W3cFrameHandler();

  @override
  final CookiesHandler cookies = new W3cCookiesHandler();

  @override
  TimeoutsHandler timeouts = new W3cTimeoutsHandler();

  @override
  LogsHandler get logs =>
      throw new UnsupportedError('Unsupported for W3cWebDriverHandler');

  @override
  WebDriverRequest buildGeneralRequest(HttpMethod method, String uri,
          [params]) =>
      new WebDriverRequest(
          method, uri, params == null ? null : json.encode(serialize(params)));

  @override
  dynamic parseGeneralResponse(
          WebDriverResponse response, dynamic Function(String) createElement) =>
      deserialize(parseW3cResponse(response), createElement);

  @override
  String toString() => "W3C";
}
