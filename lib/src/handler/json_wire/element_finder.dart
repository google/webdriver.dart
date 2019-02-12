import 'package:webdriver/src/common/by.dart';
import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/json_wire/utils.dart';

class JsonWireElementFinder extends ElementFinder {
  /// Converts [By] instances into JSON params.
  Map<String, String> _byToJson(By by) =>
      {'using': by.using, 'value': by.value};

  @override
  WebDriverRequest buildFindElementsRequest(By by, [String contextElementId]) {
    String uri = contextElementId == null
        ? 'elements'
        : 'element/$contextElementId/elements';
    return WebDriverRequest.postRequest(uri, _byToJson(by));
  }

  @override
  List<String> parseFindElementsResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response)
        .map((e) => e[jsonWireElementStr])
        .toList()
        .cast<String>();
  }

  @override
  WebDriverRequest buildFindElementRequest(By by, [String contextElementId]) {
    String uri = contextElementId == null
        ? 'element'
        : 'element/$contextElementId/element';
    return WebDriverRequest.postRequest(uri, _byToJson(by));
  }

  @override
  String parseFindActiveElementResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response)[jsonWireElementStr];
  }

  @override
  WebDriverRequest buildFindActiveElementRequest() {
    return WebDriverRequest.getRequest('element/active');
  }

  @override
  String parseFindElementResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response)[jsonWireElementStr];
  }
}
