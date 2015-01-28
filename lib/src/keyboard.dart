part of webdriver;

class Keyboard extends _WebDriverBase {

  Keyboard._(driver)
      : super(driver, '');

  /**
   * Send [keysToSend] to the active element.
   */
  Future sendKeys(String keysToSend) async {
    await _post(
        'keys',
        { 'value' : [ keysToSend ]});
  }
}
