import '../handler/infer_handler.dart';
import '../handler/json_wire_handler.dart';
import '../handler/w3c_handler.dart';
import 'spec.dart';
import 'webdriver_handler.dart';

WebDriverHandler getHandler(WebDriverSpec spec) => switch (spec) {
      WebDriverSpec.JsonWire => JsonWireWebDriverHandler(),
      WebDriverSpec.W3c => W3cWebDriverHandler(),
      WebDriverSpec.Auto => InferWebDriverHandler(),
    };
