part of webdriver;

class TargetLocator {
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  TargetLocator._(this._sessionId, this._commandProcessor);

  String get _prefix => '/session/$_sessionId';

  /**
   * Change focus to another frame on the page.
   *
   * @param frame If is a:
   *   int: select by its zero-based indexed
   *   String: select frame by the name of the frame window or the id of the
   *           frame or iframe tag.
   *   WebElement: select the frrame for a previously found frame or iframe
   *               element.
   *   not provided: selects the first frame on the page or the main document.
   *
   * @throws WebDriverError no such frame if the specified frame can't be
   * found.
   */
  Future frame([frame]) {
    if (frame is WebElement) {
      frame = frame.json;
    }
    return _commandProcessor.post('$_prefix/frame', { 'id': frame});
  }

  /**
   * Switch the focus of future commands for this driver to the window with the
   * given name/handle.
   *
   * @throws WebDriverError no such window if the specified window can't be
   * found.
   */
  Future window(String window) =>
      _commandProcessor.post('$_prefix/window', { 'name': window});

  /**
   * Switches to the currently active modal dialog for this particular driver
   * instance.
   *
   * @throws WebDriverEror no alert present if their is not currently an alert.
   */
  Future<Alert> alert() => _commandProcessor.get('$_prefix/alert_text')
      .then((text) => new Alert._(text, _commandProcessor, _sessionId));
}