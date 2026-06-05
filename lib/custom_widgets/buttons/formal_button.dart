import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Windowsのアプリケーションエラーダイアログの「OK」ボタンのような、
/// フォーマルで堅実な高重要度ボタン。
///
/// 長押しは非対応。
class FormalButton extends StatelessWidget {
  /// ボタンのテキスト。
  final String text;

  /// ボタンの文字スタイル。デフォルトのフォントサイズは `14.sp` 相当（システムフォント風）。
  final TextStyle textStyle;

  /// ボタンが有効かどうか。
  final bool isValid;

  /// ボタンが押されたときの処理。
  final VoidCallback? onPressed;

  /// ボタンの横幅。デフォルトは `100.w` 相当。
  final double _buttonWidth;

  /// ボタンの縦幅。デフォルトは `32.h` 相当（Windowsダイアログの標準的な高さに合わせる）。
  final double _buttonHeight;

  /// ボタンの角の丸み。デフォルトは極めてわずかな丸み（`BorderRadius.circular(2)`）。
  final BorderRadius _borderRadius;

  /// ボタンの影の高さ。Windowsのクラシック/モダンダイアログ仕様に合わせ、立体感は控えめ、またはフラットにします。
  final double elevation;

  /// ボタンが有効な時の背景色。デフォルトはWindowsの標準ボタン風のシックな色合い。
  final Color backgroundColor;

  /// ボタンが無効な時の背景色。
  final Color invalidColor;

  /// ボタンが有効な時の枠線の色。
  final Color? borderColor;

  /// ボタンが無効な時の枠線の色。
  final Color? invalidBorderColor;

  /// 枠線の太さと色の設定。
  final BorderSide borderSide;

  /// 左右のパディング。
  final double sidePadding;

  FormalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isValid = true,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    double? buttonWidth,
    double? buttonHeight,
    BorderRadius? borderRadius,
    this.elevation = 0.5, // 控えめな立体感
    this.backgroundColor = const Color(0xFFE1E1E1),
    this.invalidColor = const Color(0xFFF0F0F0),
    this.borderColor = const Color(0xFF0078D7),
    this.invalidBorderColor = const Color(0xFFD3D3D3),
    Color textColor = const Color(0xFF000000),
    Color invalidTextColor = const Color(0xFF838383),
    this.sidePadding = 16.0,
  }) : textStyle = TextStyle(
    fontSize: fontSize ?? 14.sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: isValid ? textColor : invalidTextColor,
    fontFamily: fontFamily,
  ),
        _buttonWidth = buttonWidth ?? 100,
        _buttonHeight = buttonHeight ?? 32,
        _borderRadius = borderRadius ?? BorderRadius.circular(2),
        borderSide = BorderSide(
          color: isValid
              ? (borderColor ?? const Color(0xFF0078D7))
              : (invalidBorderColor ?? const Color(0xFFD3D3D3)),
          width: isValid ? 1.5 : 1.0, // アクティブ時は枠線を強調してフォーカスを示す
        );

  @override
  Widget build(BuildContext context) {

    // 形の設定（シャープな角と明瞭なボーダー）
    final BoxDecoration decoration = BoxDecoration(
      borderRadius: _borderRadius,
      border: Border.fromBorderSide(borderSide),
      color: isValid ? backgroundColor : invalidColor,
      boxShadow: (elevation > 0 && isValid)
          ? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      ]
          : null,
    );

    return Container(
      constraints: BoxConstraints(
        minWidth: _buttonWidth,
        minHeight: _buttonHeight,
      ),
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: _borderRadius,
          // ホバー・押下時のフィードバックをWindowsっぽく少しだけ暗くする
          hoverColor: Colors.black.withValues(alpha: 0.03),
          highlightColor: Colors.black.withValues(alpha: 0.08),
          // スプラッシュエフェクトはなし
          splashColor: Colors.transparent,
          onTap: isValid ? onPressed : null,
          onLongPress: (){},
          child: SizedBox(
            width: _buttonWidth,
            height: _buttonHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(text, style: textStyle),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}