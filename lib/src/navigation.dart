part of webdriver;

class Navigation extends _WebDriverBase {

  Navigation._(prefix, commandProcessor) : super(prefix, commandProcessor);

  ///  Navigate forwards in the browser history, if possible.
  Future<Navigation> forward() => _post('forward').then((_) => this);

  /// Navigate backwards in the browser history, if possible.
  Future<Navigation> back() => _post('back').then((_) => this);

  /// Refresh the current page.
  Future<Navigation> refresh() => _post('refresh').then((_) => this);
}
