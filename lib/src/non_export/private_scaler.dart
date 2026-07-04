import 'dart:math';

import 'package:flutter/material.dart';

import '../../custom_widgets.dart';

// class Pixel8Util {
//
//   Pixel8Util._();
//
//   static final Pixel8Util _instance = Pixel8Util._();
//
//   factory Pixel8Util() => _instance;
//
// }

/// Google Pixel 8 のサイズを [BuildContext] から取得
extension _Pixel8MediaQuery on BuildContext{

  /// 縦幅のスケーラ
  double get pHeight => screenHeight / 914;

  /// 縦幅のスケーラ
  double get pWidth => screenWidth / 411;

  double get pr => min(pHeight, pWidth);

}

/// Google Pixel 8 のサイズを基準としたスケーラ
///
/// このパッケージ内でのみ使用。
extension PrivateScaler on num{

  /// 縦幅のスケーラ
  double pHeight(BuildContext context) => this * context.pHeight;

  /// 横幅のスケーラ
  double pWidth(BuildContext context) => this * context.pWidth;

  /// 半径のスケーラ
  double pr(BuildContext context) => this * context.pr;
}