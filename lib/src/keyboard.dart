part of webdriver;

class Keyboard extends _WebDriverBase implements Future {

  Future _future;

  Keyboard._(prefix, commandProcessor, [this._future])
      : super(prefix, commandProcessor) {
    if (_future == null) {
      _future = new Future.value();
    }
  }

  /**
   * Send a sequence of key strokes to the active element.
   *
   * @param keysToSend a String or List<String>.
   */
  Keyboard sendKeys(dynamic keysToSend) {
    if (keysToSend is String) {
      keysToSend = [ keysToSend ];
    }
    return _createNext((_) => _post(
        'keys',
        { 'value' : keysToSend as List<String>}));
  }

  Keyboard _createNext(f) {
    return new Keyboard._(_prefix, _commandProcessor, _future.then(f));
  }

  Stream asStream() => _future.asStream();

  Future catchError(onError, {test}) =>
      _future.catchError(onError, test: test);

  Future then(onValue, {onError}) =>
      _future.then(onValue, onError: onError);

  Future whenComplete(action) =>
      _future.whenComplete(action);
}