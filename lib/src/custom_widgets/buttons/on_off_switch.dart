import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/non_export/private_scaler.dart';
import 'package:custom_widgets/src/non_export/utilized_text_non_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum OnOffSwitchStyle { onWhite, onPrimary }

/// 「オン」「オフ」が明記されたトグルスイッチ
class OnOffSwitch extends HookWidget {
  /// スイッチの状態
  ///  - [true]: オン
  ///  - [false]: オフ
  final bool state;

  final ValueChanged<bool> onChanged;

  /// スイッチの初期状態
  final bool initialState;

  /// スイッチのメインカラー。
  /// 未指定の場合は、`Theme.of(context).colorScheme.primary`。
  final Color? primaryColor;

  /// スイッチの横幅。　デフォルトでは、`80`。
  final double width;

  /// スイッチの縦幅。　デフォルトでは、`38`。
  final double height;

  final double switchDiameter;

  /// スイッチの形式
  final OnOffSwitchStyle _style;

  /// 白背景の上に設置する場合
  const OnOffSwitch.onWhite({
    super.key,
    required this.state,
    required this.onChanged,
    this.initialState = false,
    this.primaryColor,
    this.width = 80,
    this.height = 38,
  }) : assert(width >= height * 2, "縦幅に対して横幅が不十分です"),
        switchDiameter = 0.75 * height,
        _style = OnOffSwitchStyle.onWhite;

  /// [primaryColor] の上に設置する場合
  const OnOffSwitch.onPrimary({
    super.key,
    required this.state,
    required this.onChanged,
    this.initialState = false,
    this.primaryColor,
    this.width = 80,
    this.height = 38,
  }) : assert(width >= height * 2, "縦幅に対して横幅が不十分です"),
       switchDiameter = 0.78 * height,
       _style = OnOffSwitchStyle.onPrimary;

  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = primaryColor ?? context.primaryColor;

    // 「オン」のときのスイッチの色
    final Color _activeSwitchColor = switch (_style) {
      OnOffSwitchStyle.onWhite => Colors.white,
      OnOffSwitchStyle.onPrimary => _primaryColor,
    };

    // 「オフ」のときのスイッチの色
    final Color _inactiveSwitchColor = switch (_style) {
      OnOffSwitchStyle.onWhite => Colors.white,
      OnOffSwitchStyle.onPrimary => Colors.white,
    };

    // スイッチの色（スイッチの状態で条件分岐）
    final Color _switchColor = state
        ? _activeSwitchColor
        : _inactiveSwitchColor;

    // 「オン」のときの背景色
    final Color _activeBackgroundColor = switch (_style) {
      OnOffSwitchStyle.onWhite => _primaryColor,
      OnOffSwitchStyle.onPrimary => Colors.white,
    };

    // 「オフ」のときの背景色
    final Color _inactiveBackgroundColor = switch (_style) {
      OnOffSwitchStyle.onWhite => Colors.black26,
      OnOffSwitchStyle.onPrimary => Colors.transparent,
    };

    // 背景色（スイッチの状態で条件分岐）
    final Color _backgroundColor = state
        ? _activeBackgroundColor
        : _inactiveBackgroundColor;

    // スイッチの枠線
    final BoxBorder? _border = switch (_style) {
      OnOffSwitchStyle.onWhite => null,
      OnOffSwitchStyle.onPrimary => state?null:Border.all(
        color: Colors.white,
        width: 1.2,
      ),
    };
    // スプラッシュエフェクトなしのボタン
    return GestureDetector(
      onTap: () => onChanged(!state),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width.pWidth(context),
        height: height.pHeight(context),
        decoration: BoxDecoration(
          // 角丸
          borderRadius: BorderRadius.circular(20),
          // 背景色
          color: _backgroundColor,
          // 枠線
          border: _border,
        ),
        child: Stack(
          children: [
            // 背景の「オン」・「オフ」テキスト
            // スイッチの状態に応じて、文字の位置と透明度をアニメーションさせる
            Align(
              // オンなら左側、オフなら右側にテキストを表示
              alignment: state ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: UtilizedText(
                  state ? "オン" : "オフ",
                  fontSize: switchDiameter * 0.54,
                  // 文字の色はスイッチと同じ色
                  color: _switchColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // スライドする丸いスイッチ
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // オンなら右側、オフなら左側にスライド
              alignment: state ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(3.0), // 枠線との間に少し余白を作る
                child: Container(
                  width: switchDiameter.pr(context),
                  height: switchDiameter.pr(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _switchColor,
                    // スイッチの影
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.15)
                        ,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
