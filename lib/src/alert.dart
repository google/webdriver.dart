part of webdriver;

/**
 * A JavaScript alert(), confirm(), or prompt() dialog
 */
class Alert {
  /**
   * The text of the JavaScript alert(), confirm(), or
   * prompt() dialog.
   */
  final String text;

  final CommandProcessor _commandProcessor;
  final String _sessionId;

  Alert._(this.text, this._commandProcessor, this._sessionId);

  String get _prefix => '/session/$_sessionId';

  /**
   * Accepts the currently displayed alert (may not be the alert for which
   * this object was created).
   *
   * @throws WebDriverError no such alert exception if there isn't currently an
   * alert.
   */
  Future accept() => _commandProcessor.post('$_prefix/accept_alert');

  /**
   * Dismisses the currently displayed alert (may not be the alert for which
   * this object was created).
   *
   * @throws WebDriverError no such alert exception if there isn't currently an
   * alert.
   */
  Future dismiss() => _commandProcessor.post('$_prefix/dismiss_alert');

  /**
   * Sends keys to the currently displayed alert (may not be the alert for which
   * this object was created).
   *
   * @throws WebDriverError no such alert exception if there isn't currently an
   * alert.
   */
  Future sendKeys(String keysToSend) =>
      _commandProcessor.post('$_prefix/alert_text', { 'text': keysToSend });
}