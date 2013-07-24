part of webdriver;

class Keyboard implements Future {

  Future _future;
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  Keyboard._(this._sessionId, this._commandProcessor, [this._future]) {
    if (_future == null) {
      _future = new Future.value();
    }
  }

  String get _prefix => '/session/$_sessionId';

  /**
   * Send a sequence of key strokes to the active element.
   */
  Keyboard sendKeys(dynamic keysToSend) {
    if (keysToSend is String) {
      keysToSend = [ keysToSend ];
    }
    return _createNext((_) => _commandProcessor.post(
        '$_prefix/keys',
        { 'value' : keysToSend as List<String>}));
  }

  Keyboard _createNext(f) {
    return new Keyboard._(_sessionId, _commandProcessor, _future.then(f));
  }

  Stream asStream() => _future.asStream();

  Future catchError(onError, {test}) =>
      _future.catchError(onError, test: test);

  Future then(onValue, {onError}) =>
      _future.then(onValue, onError: onError);

  Future whenComplete(action) =>
      _future.whenComplete(action);
}