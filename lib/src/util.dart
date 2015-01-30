part of webdriver;

const DEFAULT_TIMEOUT = const Duration(seconds: 5);
const DEFAULT_INTERVAL = const Duration(milliseconds: 500);

Future waitFor(Future predicate(), {Matcher matcher: isTrue,
    Duration timeout: DEFAULT_TIMEOUT, Duration interval: DEFAULT_INTERVAL}) {
  var endTime = new DateTime.now().add(timeout);
  var function;
  function = () async {
    var value = await predicate();
    try {
      expect(value, matcher);
      return value;
    } catch (e) {
      if (new DateTime.now().isAfter(endTime)) {
        rethrow;
      }
    }
    return await new Future.delayed(DEFAULT_INTERVAL, function);
  };
  return function();
}
