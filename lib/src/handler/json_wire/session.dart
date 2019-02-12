import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/session.dart';
import 'package:webdriver/src/common/spec.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/common/capabilities.dart';
import 'package:webdriver/src/handler/json_wire/utils.dart';

class JsonWireSessionHandler extends SessionHandler {
  @override
  WebDriverRequest buildCreateRequest({Map<String, dynamic> desired}) {
    desired ??= Capabilities.empty;
    return WebDriverRequest.postRequest(
        'session', {'desiredCapabilities': desired});
  }

  @override
  SessionInfo parseCreateResponse(WebDriverResponse response) =>
      parseInfoResponse(response);

  @override
  WebDriverRequest buildInfoRequest(String id) =>
      WebDriverRequest.getRequest('session/$id');

  @override
  SessionInfo parseInfoResponse(WebDriverResponse response) {
    final session = parseJsonWireResponse(response, valueOnly: false);
    return SessionInfo(
        session['sessionId'], WebDriverSpec.JsonWire, session['value']);
  }
}
