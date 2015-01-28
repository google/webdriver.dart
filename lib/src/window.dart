part of webdriver;


class Window extends _WebDriverBase {

  final String handle;

  Window._(driver, handle)
      : this.handle = handle,
      super(driver, 'window/$handle');

  /// The size of this window.
  Future<Size> get size async {
    var size = await _get('size');
    return new Size.fromJson(size);
  }

  /// The location of this window.
  Future<Point> get location async {
    var point = await _get('position');
    return new Point.fromJson(point);
  }

  /// Maximize this window.
  Future maximize() async {
    await _post('maximize');
  }

  /// Set this window size.
  Future setSize(Size size) async {
    await _post('size', size);
  }

  /// Set this window location.
  Future setLocation(Point point) async {
    await _post('position', point);
  }
}
