part of webdriver;


class Window extends _WebDriverBase {

  Window._(windowHandle, prefix, commandProcessor)
      : super('$prefix/window/$windowHandle', commandProcessor);

  /**
   * The size of this window.
   */
  Future<Size> get size =>  _get('size')
      .then((json) => new Size.fromJson(json));

  /**
   * The location of this window.
   */
  Future<Point> get location =>  _get('position')
      .then((json) => new Point.fromJson(json));

  /**
   * Maximize this window.
   */
  Future maximize() => _post('maximize');

  /**
   * Set this window size.
   */
  Future setSize(Size size) => _post('size', size);

  /**
   * Set this window location.
   */
  Future setLocation(Point point) => _post('position', point);
}
