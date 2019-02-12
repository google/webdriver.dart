import 'package:webdriver/src/common/spec.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/infer_handler.dart';
import 'package:webdriver/src/handler/json_wire_handler.dart';
import 'package:webdriver/src/handler/w3c_handler.dart';

WebDriverHandler getHandler(WebDriverSpec spec) {
  switch (spec) {
    case WebDriverSpec.JsonWire:
      return JsonWireWebDriverHandler();
    case WebDriverSpec.W3c:
      return W3cWebDriverHandler();
    case WebDriverSpec.Auto:
      return InferWebDriverHandler();
    default:
      throw UnsupportedError('Unexpected web driver spec: $spec.');
  }
}
