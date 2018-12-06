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
  SessionHandler get session => new JsonWireSessionHandler();

  @override
  final CoreHandler core = new JsonWireCoreHandler();

  @override
  final KeyboardHandler keyboard = new JsonWireKeyboardHandler();

  @override
  final MouseHandler mouse = new JsonWireMouseHandler();

  @override
  final ElementFinder elementFinder = new JsonWireElementFinder();

  @override
  final ElementHandler element = new JsonWireElementHandler();

  @override
  final AlertHandler alert = new JsonWireAlertHandler();

  @override
  final NavigationHandler navigation = new JsonWireNavigationHandler();

  @override
  final WindowHandler window = new JsonWireWindowHandler();

  @override
  final FrameHandler frame = new JsonWireFrameHandler();

  @override
  final CookiesHandler cookies = new JsonWireCookiesHandler();

  @override
  final TimeoutsHandler timeouts = new JsonWireTimeoutsHandler();

  @override
  final LogsHandler logs = new JsonWireLogsHandler();

  @override
  WebDriverRequest buildGeneralRequest(HttpMethod method, String uri,
          [params]) =>
      new WebDriverRequest(
          method, uri, params == null ? null : json.encode(serialize(params)));

  @override
  dynamic parseGeneralResponse(
          WebDriverResponse response, dynamic Function(String) createElement) =>
      deserialize(parseJsonWireResponse(response), createElement);

  @override
  String toString() => "JsonWire";
}
