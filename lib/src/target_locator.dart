part of webdriver;

class TargetLocator extends _WebDriverBase {

  TargetLocator._(prefix, commandProcessor) : super(prefix, commandProcessor);

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
   * Throws WebDriverError no such frame if the specified frame can't be
   * found.
   */
  Future<TargetLocator> frame([frame]) =>
      _post('frame', { 'id': frame}).then((_) => this);

  /**
   * Switch the focus of future commands for this driver to the window with the
   * given name/handle.
   *
   * Throws WebDriverError no such window if the specified window can't be
   * found.
   */
  Future<TargetLocator> window(String window) =>
      _post('window', { 'name': window}).then((_) => this);

  /**
   * Switches to the currently active modal dialog for this particular driver
   * instance.
   *
   * Throws WebDriverEror no alert present if their is not currently an alert.
   */
  Future<Alert> get alert => _get('alert_text')
      .then((text) => new Alert._(text, _prefix, _commandProcessor));
}
