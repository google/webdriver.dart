import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/session.dart';
import 'package:webdriver/src/common/spec.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/common/capabilities.dart';
import 'package:webdriver/src/handler/w3c/utils.dart';

class W3cSessionHandler extends SessionHandler {
  @override
  WebDriverRequest buildCreateRequest({Map<String, dynamic> desired}) {
    desired ??= Capabilities.empty;
    return new WebDriverRequest.postRequest('session', {
      'capabilities': {'alwaysMatch': desired}
    });
  }

  @override
  SessionInfo parseCreateResponse(WebDriverResponse response) {
    final session = parseW3cResponse(response);
    return new SessionInfo(
        session['sessionId'], WebDriverSpec.W3c, session['capabilities']);
  }

  /// Requesting existing session info is not supported in W3c.
  @override
  WebDriverRequest buildInfoRequest(String id) =>
      new WebDriverRequest.nullRequest(id);

  @override
  SessionInfo parseInfoResponse(WebDriverResponse response) =>
      new SessionInfo(response.body, WebDriverSpec.W3c, Capabilities.empty);
}
