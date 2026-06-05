import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 立体的で押し込めるボタン
/// todo 3Dアニメーション未実装
class Labeled3DButton extends StatelessWidget {
  /// ボタンの文字。
  final String text;

  /// ボタンの文字のスタイル [Text.style]。
  /// [TextStyle.fontSize] のデフォルトは、```19.sp```。
  /// [TextStyle.color] は、```isValid ? Colors.white : Colors.white ```。
  final TextStyle textStyle;

  /// ボタンが有効かどうか。
  final bool isValid;

  /// ボタン無効時にボタンを沈めておくかどうか。
  final bool isDepressedInInvalid;

  /// ボタンを押されたときの処理（[ButtonStyleButton.onPressed]）。
  final VoidCallback? onPressed;

  /// ボタンを長押ししたときの処理（[ButtonStyleButton.onLongPress]）。
  final VoidCallback? onLongPress;

  /// ボタンの横幅。デフォルトでは、```90.w```
  final double _buttonWidth;

  /// ボタンの縦幅。デフォルトでは、
  /// ``` _buttonWidth / 2  // 横幅の半分 ```
  final double _buttonHeight;

  // ボタンの枠の形。デフォルトでは、``` BorderRadius.circular(35) ```
  // final BorderRadius _borderRadius;

  /// ボタンの丸み具合。デフォルトでは、22。[_buttonHeight]の 1/4 、
  /// [_buttonWidth] の 1/2 より小さい必要がある。
  final double roundness;

  /// ボタンの側面の形を整えるための値。
  ///
  /// [thickness] + [roundness] - (遠近法分の補正値)
  ///
  /// 遠近法分の補正値 = 0.556 * [thickness] + 5.333
  ///
  final double _sideRound;

  final double _subCircular;

  /// ボタンの浮き具合
  final double elevation;

  /// ボタンが有効な時の背景色。デフォルトでは、```Colors.blue```
  final Color? backgroundColor;

  /// ボタンが無効な時の背景色。デフォルトでは、```Colors.blue.shade50```
  final Color? invalidColor;

  /// ボタンが有効な時の側面の色。デフォルトでは、```Colors.blue.shade700```
  final Color? sideColor;

  /// ボタンが無効な時の側面の色。デフォルトでは、```Colors.blue.shade400```
  final Color? invalidSideColor;

  /// 文字の両端の余白。デフォルトは、通常時（[_flexible] == false）は 8.0 、
  /// [Labeled3DButton.longText] の場合は 16.0 。
  final double sidePadding;

  /// ボタンの高さ。39.0 が限界値。
  final double thickness;

  /// 両サイドの枠の色と太さの設定（[BorderSide]）。太さは [thickness] から自動で計算される。
  /// 色は、[borderColor] と [invalidBorderColor] （[isValid] で変化）。
  ///
  /// [BorderSide.color] は non-nullable なので条件が必要。
  /// [borderColor] が null の場合は、[invalidBorderColor] は設定できず（assert）、
  /// この値は、[BorderSide.none] になる。
  ///
  /// 無効なときに枠線の色も変化させたい場合は、[invalidBorderColor] を指定する。
  final BorderSide borderSide;

  /// 正面の[BorderSide]。色は [borderSide] と同様。太さは 1.5 固定。
  final BorderSide borderFront;

  /// ボタンの側面の形。デフォルトでは、``` BorderRadius.circular(35) ```
  // final BorderRadius _sideRadius;

  /// 正面から見た両サイドの厚さ。 [thickness] から自動で計算される。
  final double sideThickness;

  final bool _flexible;

  Labeled3DButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onLongPress,
    double? fontSize,
    FontWeight? fontWeight,
    this.isValid = true,
    this.isDepressedInInvalid = false,
    double? buttonWidth,
    double? buttonHeight,
    // BorderRadius? borderRadius,
    this.roundness = 22,
    this.elevation = 0.0,
    this.backgroundColor = Colors.blue,
    this.invalidColor = const Color(0xFFE3F2FD), // Colors.blue.shade50
    this.sideColor = const Color(0xFF1976D2), // Colors.blue.shade700
    this.invalidSideColor = const Color(0xFF42A5F5), // Colors.blue.shade400
    Color textColor = Colors.white,
    Color invalidTextColor = Colors.white,
    this.thickness = 6.0,
    this.sidePadding = 8.0,
  })
      : textStyle = TextStyle(
    fontSize: fontSize ?? 19.sp,
    fontWeight: fontWeight,
    color: isValid ? textColor : invalidTextColor,
  ),
        _buttonWidth = buttonWidth ?? 90.w,
        _buttonHeight =
            buttonHeight ?? (buttonWidth != null ? buttonWidth / 2 : 45.h),
  // _borderRadius = borderRadius ?? BorderRadius.circular(35),
  // todo 自動で計算
  // roundness + thickness - (0.556 * thickness + 5.333)
        _sideRound = roundness + 0.444 * thickness - 5.333,

        _subCircular = roundness > thickness ? roundness - thickness: 0,

  // _sideRadius = borderRadius ?? BorderRadius.circular(35),
        sideThickness = 0.229 * thickness + 0.125,
  // borderColor が指定されていなければ、BorderSide.none
        borderSide = (sideColor != null)
            ? BorderSide(
          // 無効なときに枠線の色も変化させたい場合は、invalidBorderColor を指定する
          color: isValid ? sideColor : (invalidSideColor ?? sideColor),
          // 自動で計算
          width: 0.229 * thickness + 0.125,
        )
            : BorderSide.none,
        borderFront = (sideColor != null)
            ? BorderSide(
          // 無効なときに枠線の色も変化させたい場合は、invalidBorderColor を指定する
          color: isValid ? sideColor : (invalidSideColor ?? sideColor),
          width: 1.5,
        )
            : BorderSide.none,

        _flexible = false,

  // 無効なときの枠線だけを設定している場合は assert
        assert(!(sideColor == null && invalidSideColor != null), "枠線の設定"),
        assert((buttonWidth != null ? buttonWidth / 2 : 45.h)
            >= roundness *2, "roundness が大きすぎます"),
        assert(thickness <= 80.0, "thickness は 80.0 が限界値です");

  /// 文字が長い場合に、文字を小さくするのではなく、ボタンの横幅を広げる
  Labeled3DButton.longText({
    super.key,
    required this.text,
    required this.onPressed,
    this.onLongPress,
    double? fontSize,
    FontWeight? fontWeight,
    this.isValid = true,
    this.isDepressedInInvalid = false,
    double? buttonWidth,
    double? buttonHeight,
    // BorderRadius? borderRadius,
    this.roundness = 22,
    this.elevation = 0.0,
    this.backgroundColor = Colors.blue,
    this.invalidColor = const Color(0xFFE3F2FD), // Colors.blue.shade50
    this.sideColor = const Color(0xFF1976D2), // Colors.blue.shade700
    this.invalidSideColor = const Color(0xFF42A5F5), // Colors.blue.shade400
    Color textColor = Colors.white,
    Color invalidTextColor = Colors.white,
    this.thickness = 6.0,
    this.sidePadding = 16.0,
  })
      : textStyle = TextStyle(
    fontSize: fontSize ?? 19.sp,
    fontWeight: fontWeight,
    color: isValid ? textColor : invalidTextColor,
  ),
        _buttonWidth = buttonWidth ?? 90.w,
        _buttonHeight =
            buttonHeight ?? (buttonWidth != null ? buttonWidth / 2 : 45.h),
  // _borderRadius = borderRadius ?? BorderRadius.circular(35),
  // todo 自動で計算
  // roundness + thickness - (0.556 * thickness + 5.333)
        _sideRound = roundness + 0.444 * thickness - 5.333,

        _subCircular = roundness > thickness ? roundness - thickness: 0,

  // _sideRadius = BorderRadius.circular(20),
        sideThickness = 0.229 * thickness + 0.125,
  // borderColor が指定されていなければ、BorderSide.none
        borderSide = (sideColor != null)
            ? BorderSide(
          // 無効なときに枠線の色も変化させたい場合は、invalidSideColor を指定する
          color: isValid ? sideColor : (invalidSideColor ?? sideColor),
          // 自動で計算
          width: 0.229 * thickness + 0.125,
        )
            : BorderSide.none,
        borderFront = (sideColor != null)
            ? BorderSide(
          // 無効なときに枠線の色も変化させたい場合は、invalidSideColor を指定する
          color: isValid ? sideColor : (invalidSideColor ?? sideColor),
          width: 1.5,
        )
            : BorderSide.none,
        _flexible = true,

  // 無効なときの枠線だけを設定している場合は assert
        assert(!(sideColor == null && invalidSideColor != null), "枠線の設定"),
        assert((buttonWidth != null ? buttonWidth / 2 : 45.h)
            >= roundness *2, "roundness が大きすぎます"),
        assert(thickness <= 80.0, "thickness は 80.0 が限界値です")
  {
    _print("_sideRound = $_sideRound", "_subCircular = $_subCircular");
  }

  @override
  Widget build(BuildContext context) {
    // ボタンの中身。通常（_flexible == false）は、後者（ボタンサイズが固定で文字がはみ
    // 出る場合はボタンサイズが横に大きくなる）。.longText の場合（_flexible == true）は
    // 、前者（文字サイズが固定で文字がはみ出る場合は文字を小さくする）。
    final Widget _content = _flexible
        ? Center(child: Text(text, style: textStyle, maxLines: 1))
        : Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, style: textStyle),
      ),
    );

    // 無効時は厚みをなくして「押し込まれた」状態を表現
    final double depth = isDepressedInInvalid
        ? isValid
        ? thickness
        : 0.0
        : thickness;

    return SizedBox(
      // 自動で計算
      width: _flexible ? null : _buttonWidth + 2 * (sideThickness),
      // 厚みの分だけ高さを確保
      height: _buttonHeight + thickness,
      child: Stack(
        children: [
          // 底面（ボタンの「厚み／側面」の部分）
          Container(
            constraints: BoxConstraints(
              minWidth: _buttonWidth + 2 * (sideThickness),
              minHeight: _buttonHeight,
            ),
            // width: _flexible ? null : _buttonWidth + 2 * (sideThickness),
            // height: _buttonHeight,
            margin: EdgeInsets.only(top: thickness),
            // 表面が浮くスペースを上に確保
            decoration: BoxDecoration(
              color: isValid ? sideColor : invalidSideColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_subCircular),
                topRight: Radius.circular(_subCircular),
                bottomLeft: Radius.circular(roundness),
                bottomRight: Radius.circular(roundness),
              ),
            ),
            // .flexible の時は、中身のサイズを測るために同じ Padding を持たせる
            child: _flexible
                ? IntrinsicWidth(
              child: Padding(
                // 自動で計算
                padding: EdgeInsets.symmetric(
                  horizontal: sidePadding + (sideThickness),
                ),
                // サイズ測定用（見えない）
                child: Opacity(opacity: 0, child: _content),
              ),
            )
                : null,
          ),
          // 側面
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            bottom: depth,
            child: Container(
              constraints: BoxConstraints(
                minWidth: _buttonWidth + 2 * (sideThickness),
                minHeight: _buttonHeight,
              ),
              width: _flexible ? null : _buttonWidth + 2 * (sideThickness),
              height: _buttonHeight,
              // margin: EdgeInsets.only(top: thickness),
              // ボタンの高さに合わせて、側面の形を形成
              decoration: BoxDecoration(
                color: isValid ? sideColor : invalidSideColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_sideRound),
                  topRight: Radius.circular(_sideRound),
                  bottomLeft: Radius.circular(_subCircular),
                  bottomRight: Radius.circular(_subCircular),
                ),
                // borderRadius: BorderRadius.circular(_sideRound),
              ),
              // .flexible の時は、中身のサイズを測るために同じ Padding を持たせる
              child: _flexible
                  ? IntrinsicWidth(
                child: Padding(
                  // 自動で計算
                  padding: EdgeInsets.symmetric(
                    horizontal: sidePadding + (sideThickness),
                  ),
                  // サイズ測定用（見えない）
                  child: Opacity(opacity: 0, child: _content),
                ),
              )
                  : null,
            ),
          ),
          //  表面（実際にタップする部分）
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: sideThickness,
            bottom: depth, // 有効時は上に浮かせ、無効時は下に下げる
            child: Material(
              color: isValid ? backgroundColor : invalidColor,
              borderRadius: BorderRadius.circular(roundness),
              child: InkWell(
                onTap: isValid ? onPressed : null,
                onLongPress: isValid ? onLongPress : null,
                borderRadius: BorderRadius.circular(roundness),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: _buttonWidth,
                    minHeight: _buttonHeight,
                  ),
                  width: _flexible ? null : _buttonWidth,
                  height: _buttonHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: borderFront),
                    borderRadius: BorderRadius.circular(roundness),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sidePadding),
                    child: _content,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// todo printメソッド [3Dボタン]
_print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[3Dボタン]　" + s1);
    if (s2 != null) print("[3Dボタン]　" + s2);
    if (s3 != null) print("[3Dボタン]　" + s3);
    if (s4 != null) print("[3Dボタン]　" + s4);
    if (s5 != null) print("[3Dボタン]　" + s5);
    print("");
  }
}
