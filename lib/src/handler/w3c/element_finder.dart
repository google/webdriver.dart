import '../../common/by.dart';
import '../../common/request.dart';
import '../../common/webdriver_handler.dart';
import 'utils.dart';

class W3cElementFinder extends ElementFinder {
  /// Here we massage [By] instances into viable W3C /element requests.
  ///
  /// In principle, W3C spec implementations should be nearly the same as
  /// the existing JSON wire spec. In practice compliance is uneven.
  Map<String, String> _byToJson(By by) {
    final (using, value) = switch (by.using) {
      // This doesn't exist in the W3C spec.
      'id' => ('css selector', '#${by.value}'),

      // This doesn't exist in the W3C spec.
      'name' => ('css selector', '[name=${by.value}]'),

      // This is in the W3C spec, but not in geckodriver.
      'tag name' => ('css selector', by.value),

      // This doesn't exist in the W3C spec.
      'class name' => ('css selector', '.${by.value}'),

      // xpath, css selector, link text, partial link text, seem fine.
      _ => (by.using, by.value),
    };

    return {'using': using, 'value': value};
  }

  @override
  WebDriverRequest buildFindElementsRequest(By by, [String? contextId]) {
    final uri = '${elementPrefix(contextId)}elements';
    return WebDriverRequest.postRequest(uri, _byToJson(by));
  }

  @override
  List<String> parseFindElementsResponse(WebDriverResponse response) =>
      (parseW3cResponse(response) as List)
          .map<String>((e) => (e as Map)[w3cElementStr] as String)
          .toList();

  @override
  WebDriverRequest buildFindElementRequest(By by, [String? contextId]) {
    final uri = '${elementPrefix(contextId)}element';
    return WebDriverRequest.postRequest(uri, _byToJson(by));
  }

  @override
  String? parseFindActiveElementResponse(WebDriverResponse response) =>
      (parseW3cResponse(response) as Map)[w3cElementStr] as String;

  @override
  WebDriverRequest buildFindActiveElementRequest() =>
      WebDriverRequest.getRequest('element/active');

  @override
  String? parseFindElementResponseCore(WebDriverResponse response) =>
      (parseW3cResponse(response) as Map?)?[w3cElementStr] as String?;
}
