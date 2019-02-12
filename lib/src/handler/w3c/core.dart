import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/w3c/utils.dart';

class W3cCoreHandler extends CoreHandler {
  @override
  WebDriverRequest buildCurrentUrlRequest() =>
      WebDriverRequest.getRequest('url');

  @override
  String parseCurrentUrlResponse(WebDriverResponse response) =>
      parseW3cResponse(response);

  @override
  WebDriverRequest buildTitleRequest() => WebDriverRequest.getRequest('title');

  @override
  String parseTitleResponse(WebDriverResponse response) =>
      parseW3cResponse(response);

  @override
  WebDriverRequest buildPageSourceRequest() =>
      WebDriverRequest.getRequest('source');

  @override
  String parsePageSourceResponse(WebDriverResponse response) =>
      parseW3cResponse(response);

  @override
  WebDriverRequest buildScreenshotRequest() =>
      WebDriverRequest.getRequest('screenshot');

  @override
  String parseScreenshotResponse(WebDriverResponse response) =>
      parseW3cResponse(response);

  @override
  WebDriverRequest buildExecuteAsyncRequest(String script, List args) =>
      WebDriverRequest.postRequest(
          'execute/async', {'script': script, 'args': serialize(args)});

  @override
  dynamic parseExecuteAsyncResponse(
          WebDriverResponse response, dynamic Function(String) createElement) =>
      deserialize(parseW3cResponse(response), createElement);

  @override
  WebDriverRequest buildExecuteRequest(String script, List args) =>
      WebDriverRequest.postRequest(
          'execute/sync', {'script': script, 'args': serialize(args)});

  @override
  dynamic parseExecuteResponse(
          WebDriverResponse response, dynamic Function(String) createElement) =>
      deserialize(parseW3cResponse(response), createElement);

  @override
  WebDriverRequest buildDeleteSessionRequest() =>
      WebDriverRequest.deleteRequest('');

  @override
  void parseDeleteSessionResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }
}
