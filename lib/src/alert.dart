part of webdriver;


/// A JavaScript alert(), confirm(), or prompt() dialog
class Alert extends _WebDriverBase {
  /**
   * The text of the JavaScript alert(), confirm(), or
   * prompt() dialog.
   */
  final String text;


  Alert._(this.text, prefix, commandProcessor)
      : super(prefix, commandProcessor);

  /**
   * Accepts the currently displayed alert (may not be the alert for which
   * this object was created).
   *
   * @throws WebDriverError no such alert exception if there isn't currently an
   * alert.
   */
  Future<Alert> accept() => _post('accept_alert').then((_) => this);

  /**
   * Dismisses the currently displayed alert (may not be the alert for which
   * this object was created).
   *
   * Throws WebDriverError no such alert exception if there isn't currently an
   * alert.
   */
  Future<Alert> dismiss() => _post('dismiss_alert').then((_) => this);

  /**
   * Sends keys to the currently displayed alert (may not be the alert for which
   * this object was created).
   *
   * Throws WebDriverError no such alert exception if there isn't currently an
   * alert.
   */
  Future<Alert> sendKeys(String keysToSend) =>
      _post('alert_text', { 'text': keysToSend }).then((_) => this);
}
