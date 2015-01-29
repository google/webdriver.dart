part of webdriver;

class Navigation extends _WebDriverBase {
  Navigation._(driver) : super(driver, '');

  ///  Navigate forwards in the browser history, if possible.
  Future forward() async {
    await _post('forward');
  }

  /// Navigate backwards in the browser history, if possible.
  Future back() async {
    await _post('back');
  }

  /// Refresh the current page.
  Future refresh() async {
    await _post('refresh');
  }
}
