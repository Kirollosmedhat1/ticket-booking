class ScreenSizeHandler {

  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _bigger = 0;
  static double _smaller = 0;

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get bigger => _bigger;
  static double get smaller => _smaller;

  static void initialize(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;

    if (_screenWidth > _screenHeight) {
      _bigger = _screenWidth;
      _smaller = _screenHeight;
    } else {
      _bigger = _screenHeight;
      _smaller = _screenWidth;
    }
  }
}