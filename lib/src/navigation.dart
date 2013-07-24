part of webdriver;

class Navigation {
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  Navigation._(this._sessionId, this._commandProcessor);

  String get _prefix => '/session/$_sessionId';

  /**
   * Navigate forwards in the browser history, if possible.
   */
  Future forward() => _commandProcessor.post('$_prefix/forward');

  /**
   * Navigate backwards in the browser history, if possible.
   */
  Future back() => _commandProcessor.post('$_prefix/back');

  /**
   * Refresh the current page.
   */
  Future refresh() => _commandProcessor.post('$_prefix/refresh');
}