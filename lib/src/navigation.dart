part of webdriver;

class Navigation extends _WebDriverBase {

  Navigation._(prefix, commandProcessor) : this(prefix, commandProcessor);

  /**
   * Navigate forwards in the browser history, if possible.
   */
  Future forward() => _post('forward');

  /**
   * Navigate backwards in the browser history, if possible.
   */
  Future back() => _post('back');

  /**
   * Refresh the current page.
   */
  Future refresh() => _post('refresh');
}