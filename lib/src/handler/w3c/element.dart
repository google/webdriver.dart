import '../../common/geometry.dart';
import '../../common/request.dart';
import '../../common/webdriver_handler.dart';
import 'utils.dart';

class W3cElementHandler extends ElementHandler {
  @override
  WebDriverRequest buildClickRequest(String elementId) =>
      WebDriverRequest.postRequest('${elementPrefix(elementId)}click');

  @override
  void parseClickResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildSendKeysRequest(String elementId, String keysToSend) =>
      WebDriverRequest.postRequest('${elementPrefix(elementId)}value', {
        'text': keysToSend, // What geckodriver really wants.
        'value': keysToSend // Actual W3C spec.
      });

  @override
  void parseSendKeysResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildClearRequest(String elementId) =>
      WebDriverRequest.postRequest('${elementPrefix(elementId)}clear');

  @override
  void parseClearResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildSelectedRequest(String elementId) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}selected');

  @override
  bool parseSelectedResponse(WebDriverResponse response) =>
      parseW3cResponse(response) as bool;

  @override
  WebDriverRequest buildEnabledRequest(String elementId) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}enabled');

  @override
  bool parseEnabledResponse(WebDriverResponse response) =>
      parseW3cResponse(response) as bool;

  @override
  WebDriverRequest buildDisplayedRequest(String elementId) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}displayed');

  @override
  bool parseDisplayedResponse(WebDriverResponse response) =>
      parseW3cResponse(response) as bool;

  @override
  WebDriverRequest buildLocationRequest(String elementId) =>
      _buildRectRequest(elementId);

  @override
  Position parseLocationResponse(WebDriverResponse response) =>
      _parseRectResponse(response).topLeft;

  @override
  WebDriverRequest buildSizeRequest(String elementId) =>
      _buildRectRequest(elementId);

  @override
  Size parseSizeResponse(WebDriverResponse response) {
    final rect = _parseRectResponse(response);
    return rect.size;
  }

  WebDriverRequest _buildRectRequest(String elementId) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}rect');

  Rect _parseRectResponse(WebDriverResponse response) {
    final rect = parseW3cResponse(response);
    return Rect(
      left: (rect['x'] as num).toInt(),
      top: (rect['y'] as num).toInt(),
      width: (rect['width'] as num).toInt(),
      height: (rect['height'] as num).toInt(),
    );
  }

  @override
  WebDriverRequest buildNameRequest(String elementId) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}name');

  @override
  String parseNameResponse(WebDriverResponse response) =>
      parseW3cResponse(response) as String;

  @override
  WebDriverRequest buildTextRequest(String elementId) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}text');

  @override
  String parseTextResponse(WebDriverResponse response) =>
      parseW3cResponse(response) as String;

  @override
  WebDriverRequest buildAttributeRequest(String elementId, String name) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}attribute/$name');

  @override
  String? parseAttributeResponse(WebDriverResponse response) =>
      parseW3cResponse(response)?.toString();

  @override
  @Deprecated('Only used to support the old page loader.')
  WebDriverRequest buildSeleniumAttributeRequest(
          String elementId, String name) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}attribute/$name');

  @override
  @Deprecated('Only used to support the old page loader.')
  String? parseSeleniumAttributeResponse(WebDriverResponse response) =>
      parseW3cResponse(response)?.toString();

  @override
  WebDriverRequest buildCssPropertyRequest(String elementId, String name) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}css/$name');

  @override
  String? parseCssPropertyResponse(WebDriverResponse response) =>
      parseW3cResponse(response)?.toString();

  @override
  WebDriverRequest buildPropertyRequest(String elementId, String name) =>
      WebDriverRequest.getRequest('${elementPrefix(elementId)}property/$name');

  @override
  String? parsePropertyResponse(WebDriverResponse response) =>
      parseW3cResponse(response)?.toString();
}
