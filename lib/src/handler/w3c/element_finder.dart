import 'package:webdriver/src/common/by.dart';
import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/w3c/utils.dart';

class W3cElementFinder extends ElementFinder {
  /// Here we massage [By] instances into viable W3C /element requests.
  ///
  /// In principle, W3C spec implementations should be nearly the same as
  /// the existing JSON wire spec. In practice compliance is uneven.
  Map<String, String> _byToJson(By by) {
    String using;
    String value;

    switch (by.using) {
      case 'id': // This doesn't exist in the W3C spec.
        using = 'css selector';
        value = '#${by.value}';
        break;
      case 'name': // This doesn't exist in the W3C spec.
        using = 'css selector';
        value = '[name=${by.value}]';
        break;
      case 'tag name': // This is in the W3C spec, but not in geckodriver.
        using = 'css selector';
        value = by.value;
        break;
      // xpath, css selector, link text, partial link text, seem fine.
      default:
        using = by.using;
        value = by.value;
    }

    return {'using': using, 'value': value};
  }

  @override
  WebDriverRequest buildFindElementsRequest(By by, [String contextElementId]) {
    String uri = '${elementPrefix(contextElementId)}elements';
    return WebDriverRequest.postRequest(uri, _byToJson(by));
  }

  @override
  List<String> parseFindElementsResponse(WebDriverResponse response) {
    return (parseW3cResponse(response) as List)
        .map<String>((e) => e[w3cElementStr])
        .toList();
  }

  @override
  WebDriverRequest buildFindElementRequest(By by, [String contextElementId]) {
    String uri = '${elementPrefix(contextElementId)}element';
    return WebDriverRequest.postRequest(uri, _byToJson(by));
  }

  @override
  String parseFindActiveElementResponse(WebDriverResponse response) {
    return parseW3cResponse(response)[w3cElementStr];
  }

  @override
  WebDriverRequest buildFindActiveElementRequest() {
    return WebDriverRequest.getRequest('element/active');
  }

  @override
  String parseFindElementResponse(WebDriverResponse response) {
    return parseW3cResponse(response)[w3cElementStr];
  }
}
