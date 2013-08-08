part of webdriver;


class Window extends _WebDriverBase {

  Window._(windowHandle, prefix, commandProcessor)
      : super('$prefix/window/$windowHandle', commandProcessor);

  /// The size of this window.
  Future<Size> get size =>  _get('size')
      .then((json) => new Size.fromJson(json));

  /// The location of this window.
  Future<Point> get location =>  _get('position')
      .then((json) => new Point.fromJson(json));

  /// Maximize this window.
  Future<Window> maximize() => _post('maximize').then((_) => this);

  /// Set this window size.
  Future<Window> setSize(Size size) => _post('size', size).then((_) => this);

  /// Set this window location.
  Future<Window> setLocation(Point point) =>
      _post('position', point).then((_) => this);
}
