import 'package:flutter/material.dart';

class AppConfig {
  double _height;
  double _width;
  double _paddingWidth;
  double _paddingHeight;

  BuildContext _context;

  AppConfig(this._context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(_context);
    _height = _mediaQueryData.size.height / 100;
    _width = _mediaQueryData.size.width / 100;
    _paddingHeight =
        _height - ((_mediaQueryData.padding.top + _mediaQueryData.padding.bottom) / 100);
    _paddingWidth =
        _width - ((_mediaQueryData.padding.left + _mediaQueryData.padding.right) / 100);
  }

  double setHeight(double val) => _height * val;
  double setWidth(double val) => _width * val;
  double setHeightPadding(double val) => _paddingHeight * val;
  double setWidthPadding(double val) => _paddingWidth * val;

  @override
  String toString() {
    return "Height: $_height\nWidth: $_width\nHeight-Padding: $_paddingHeight\nWidth-Padding: $_paddingWidth";
  }
}
