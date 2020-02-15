import 'dart:convert';

import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/json_wire/alert.dart';
import 'package:webdriver/src/handler/json_wire/cookies.dart';
import 'package:webdriver/src/handler/json_wire/core.dart';
import 'package:webdriver/src/handler/json_wire/element.dart';
import 'package:webdriver/src/handler/json_wire/element_finder.dart';
import 'package:webdriver/src/handler/json_wire/frame.dart';
import 'package:webdriver/src/handler/json_wire/keyboard.dart';
import 'package:webdriver/src/handler/json_wire/logs.dart';
import 'package:webdriver/src/handler/json_wire/mouse.dart';
import 'package:webdriver/src/handler/json_wire/navigation.dart';
import 'package:webdriver/src/handler/json_wire/session.dart';
import 'package:webdriver/src/handler/json_wire/timeouts.dart';
import 'package:webdriver/src/handler/json_wire/utils.dart';
import 'package:webdriver/src/handler/json_wire/window.dart';

class JsonWireWebDriverHandler extends WebDriverHandler {
  @override
  SessionHandler get session => JsonWireSessionHandler();

  @override
  final CoreHandler core = JsonWireCoreHandler();

  @override
  final KeyboardHandler keyboard = JsonWireKeyboardHandler();

  @override
  final MouseHandler mouse = JsonWireMouseHandler();

  @override
  final ElementFinder elementFinder = JsonWireElementFinder();

  @override
  final ElementHandler element = JsonWireElementHandler();

  @override
  final AlertHandler alert = JsonWireAlertHandler();

  @override
  final NavigationHandler navigation = JsonWireNavigationHandler();

  @override
  final WindowHandler window = JsonWireWindowHandler();

  @override
  final FrameHandler frame = JsonWireFrameHandler();

  @override
  final CookiesHandler cookies = JsonWireCookiesHandler();

  @override
  final TimeoutsHandler timeouts = JsonWireTimeoutsHandler();

  @override
  final LogsHandler logs = JsonWireLogsHandler();

  @override
  WebDriverRequest buildGeneralRequest(HttpMethod method, String uri,
          [params]) =>
      WebDriverRequest(
          method, uri, params == null ? null : json.encode(serialize(params)));

  @override
  dynamic parseGeneralResponse(
          WebDriverResponse response, dynamic Function(String) createElement) =>
      deserialize(parseJsonWireResponse(response), createElement);

  @override
  String toString() => 'JsonWire';
}
