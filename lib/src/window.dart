part of webdriver;


class Window {
  final String _sessionId;
  final CommandProcessor _commandProcessor;
  final String _windowHandle;

  Window._(this._sessionId, this._commandProcessor, this._windowHandle);

  String get _prefix => '/session/$_sessionId/window/$_windowHandle';

  /**
   * The size of this window.
   */
  Future<Size> get size =>  _commandProcessor.get('$_prefix/size')
      .then((json) => new Size.fromJson(json));

  /**
   * The location of this window.
   */
  Future<Point> get location =>  _commandProcessor.get('$_prefix/position')
      .then((json) => new Point.fromJson(json));

  /**
   * Maximize this window.
   */
  Future maximize() => _commandProcessor.post('$_prefix/maximize');

  /**
   * Set this window size.
   */
  Future setSize(Size size) =>
      _commandProcessor.post('$_prefix/size', size.json);

  /**
   * Set this window location.
   */
  Future setLocation(Point point) =>
      _commandProcessor.post('$_prefix/position', point.json);
}