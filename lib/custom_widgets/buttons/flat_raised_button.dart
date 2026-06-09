import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/custom_widgets/buttons/buttons_custom_enumerations.dart';
import 'package:custom_widgets/custom_widgets/texts/utilized_text.dart';
import 'package:custom_widgets/extensions/extensions_build_context.dart';
import 'package:custom_widgets/non_export/utilized_text_non_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlatRaisedButton extends HookWidget {
  const FlatRaisedButton.sync({
    super.key,
    required this.text,
    double fontSize = 25,
    bool isBoldText = false,
    this.textColor,
    this.backgroundColor,
    required this.onPressedSync,
    required this.height,
    required this.width,
    this.borderRadius,
    this.borderSide,
    required this.isValid,
  }) : assert(onPressedSync != null, "処理の内容が設定されていません。（FlatRaisedButton.sync）"),
       onPressedAsync = null,
       _fontSize = fontSize,
       _fontWeight = isBoldText ? FontWeight.bold : null,
       processType = ProcessType.sync;

  const FlatRaisedButton.async({
    super.key,
    required this.text,
    double fontSize = 25,
    bool isBoldText = false,
    this.textColor,
    this.backgroundColor,
    required this.onPressedAsync,
    required this.height,
    required this.width,
    this.borderRadius,
    this.borderSide,
    required this.isValid,
  }) : assert(
         onPressedAsync != null,
         "処理の内容が設定されていません。（FlatRaisedButton.async）",
       ),
       onPressedSync = null,
       _fontSize = fontSize,
       _fontWeight = isBoldText ? FontWeight.bold : null,
       processType = ProcessType.async;

  // isTest = false;

  /// ボタンの文字部分。
  final String text;

  /// 文字サイズ。　デフォルトでは、`25` 。
  final double _fontSize;

  /// 文字の太さ。
  final FontWeight? _fontWeight;

  /// 文字の色。 指定しない場合は、`Theme` を参照する。
  final Color? textColor;

  /// ボタンの背景色。指定しない場合は、`Theme` を参照する。
  final Color? backgroundColor;

  /// ボタンの高さ
  final double height;

  /// ボタンの横幅
  final double width;

  /// ボタンタップ時の処理。
  ///
  /// 同じスレッドで処理を進める場合は、ここに設定し、[onPressedAsync] を `null` にする。
  final VoidCallback? onPressedSync;

  /// ボタンタップ時の処理。
  ///
  /// 非同期で処理を進める場合は、ここに設定し、[onPressedSync] を `null` にする。
  final Future<void> Function()? onPressedAsync;

  /// ボタンの角丸。　デフォルトは、`BorderRadius.circular(10)` 。
  final BorderRadius? borderRadius;

  /// ボタンの枠線の詳細設定（色や太さ）。デフォルトでは、枠線なし（）。
  final BorderSide? borderSide;

  final bool isValid;

  final ProcessType processType;

  // region 変更のテスト用
  // final bool isTest;
  //
  // const FullWidthButton.test({
  //   super.key,
  //   required this.text,
  //   double fontSize = 25,
  //   bool isBoldText = false,
  //   this.textColor,
  //   this.backgroundColor,
  //   this.height,
  //   this.onPressedSync,
  //   this.onPressedAsync,
  // }) : assert(
  //        onPressedSync != null || onPressedAsync != null,
  //        "処理の内容が設定されていません。（FullWidthButton）",
  //      ),
  //      assert(
  //        onPressedSync == null || onPressedAsync == null,
  //        "処理の内容が重複しています。（FullWidthButton）",
  //      ),
  //      _fontSize = fontSize,
  //      _fontWeight = isBoldText ? FontWeight.bold : null,
  //      isTest = true;
  // endregion

  @override
  Widget build(BuildContext context) {
    // 背景色の指定がなかった場合は、context からテーマカラーを参照する
    final Color _backgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;

    final BorderSide _borderSide = BorderSide(style: BorderStyle.none);

    final BorderRadius _borderRadius =
        borderRadius ?? BorderRadius.circular(10);

    // 押下状態を管理
    final _isPressed = useState<bool>(false);

    final _isOnProcess = useState<bool>(false);

    final isPressDown = _isPressed.value || _isOnProcess.value;

    // ニューモーフィズム的な影の配置
    final List<BoxShadow> boxShadows = isPressDown
        ?
          // 押下時
          [
            // 全体の最背面
            BoxShadow(
              color: _backgroundColor,
              // 押下時は少し浅くする
              spreadRadius: 3.5,
              blurRadius: 3.0,
              offset: const Offset(1.5, 1.5),
            ),
            // 左上（凸時の強い光が当たるハイライト面）
            BoxShadow(
              // 押下時は光を少し弱くする
              color: Colors.white.withValues(alpha: 0.6),
              spreadRadius: 2.5,
              blurRadius: 4.0,
              // 浅くなった最背面に合わせる
              offset: const Offset(-2.5, -2.5),
            ),
            // 右下（凸時の接地感を出すソフトな影面）
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2.0,
              blurRadius: 7.0,
              // 浅くなった最背面に合わせる
              offset: const Offset(2.5, 2.5),
            ),
          ]
        : [
            // 通常時
            // 全体の最背面
            BoxShadow(
              color: _backgroundColor,
              spreadRadius: 4.0,
              blurRadius: 5.0,
              offset: const Offset(1.5, 1.5),
            ),
            // 左上（凸時の強い光が当たるハイライト面）
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              spreadRadius: 2.5,
              blurRadius: 4.0,
              offset: const Offset(-3, -3),
            ),
            // 右下（凸時の接地感を出すソフトな影面）
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              spreadRadius: 1.0,
              blurRadius: 10.0,
              offset: const Offset(3, 3),
            ),
          ];

    final Widget body = AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      // 押下時に右下方向に実際に移動させることで、3Dの押し込み感を演出
      // transform: isPressDown && isValid
      //     ? Matrix4.translationValues(1.4, 1.4, 0)
      //     : Matrix4.translationValues(0, 0, 0),
      constraints: BoxConstraints(minWidth: width, minHeight: height ?? 90.h),
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        border: Border.fromBorderSide(_borderSide),
        color: backgroundColor,
        boxShadow: boxShadows,
      ),
      // クリップを適用することで、沈み込んだ時にボタン外側（右下など）にはみ出そうとする影をカット。
      // これにより、影が「上と左のフチの内側だけ」に入り込んだように見せます。
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          // ボーダーの太さ分、クリップ半径を微調整
          (_borderRadius.topLeft.x - _borderSide.width).clamp(
            0.0,
            double.infinity,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: _borderRadius,
            hoverColor: Colors.black.withValues(alpha: 0.03),
            highlightColor: Colors.black.withValues(alpha: 0.06),
            splashColor: Colors.transparent,
            onTap: isValid
                ? () async {
                    _isOnProcess.value = true;
                    switch (processType) {
                      case ProcessType.sync:
                        onPressedSync!();
                      case ProcessType.async:
                        await onPressedAsync!();
                    }
                    _isOnProcess.value = false;
                  }
                : null,
            onTapDown: isValid
                ? (_) {
                    _isPressed.value = true;
                  }
                : null,
            onTapUp: isValid
                ? (_) async {
                    await Future.delayed(const Duration(milliseconds: 50));
                    _isPressed.value = false;
                  }
                : null,
            onTapCancel: isValid
                ? () {
                    _isPressed.value = false;
                  }
                : null,
            onLongPress: null,
            child: SizedBox(
              width: width,
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: UtilizedText(
                    text,
                    fontSize: _fontSize,
                    fontWeight: _fontWeight,
                    color: textColor ?? Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 8.0.w),
      child: switch (processType) {
        ProcessType.sync => body,
        ProcessType.async => LoadableWidget(
          childBorderRadius: _borderRadius,
          // 非同期処理実行中にぐるぐるを表示する
          isLoading: _isOnProcess.value,
          child: body,
        ),
      },
    );
  }
}

// class TestCard extends StatelessWidget {
//   TestCard({super.key});
//
//   Color _lightColor(Color baseColor) {
//     // HSL形式に変換
//     final HSLColor hslColor = HSLColor.fromColor(baseColor);
//
//     // 輝度（lightness）を上げる（最大値は 1.0）
//     // 例：現在の輝度に 0.15 を加算する（上限 1.0 に制限）
//     final HSLColor lighterHslColor = hslColor.withLightness(
//       (hslColor.lightness + 0.15).clamp(0.0, 1.0),
//     );
//
//     // 再び Color オブジェクトに戻す
//     return lighterHslColor.toColor();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double width = context.screenWidth * 0.5;
//     return Padding(
//       padding: EdgeInsets.only(left: 12.r, top: 8.r, right: 6.r, bottom: 12.r),
//       child: Container(
//         decoration: BoxDecoration(
//           // ニューモーフィズム
//           boxShadow: draft1,
//           // boxShadow: draft2,
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.green.shade400,
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(left: 12.r, top: 12.r, right: 12.r),
//             child: SizedBox(width: width, height: width),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<BoxShadow> draft1 = <BoxShadow>[
//     // 全体の最背面
//     BoxShadow(
//       // color: Colors.brown.shade200,
//       color: Colors.green,
//       spreadRadius: 4,
//       blurRadius: 5,
//       // 暗い側に少し寄せる
//       offset: Offset(1, 1),
//     ),
//     // 左上
//     BoxShadow(
//       color: Colors.white.withValues(alpha: 0.8),
//       spreadRadius: 2.5,
//       blurRadius: 4,
//       offset: Offset(-3, -3),
//     ),
//     // 右下
//     BoxShadow(
//       // color: Colors.brown.shade200,
//       // color: Colors.green.withValues(alpha: 0.3),
//       color: Colors.black.withValues(alpha: 0.3),
//       spreadRadius: 1,
//       blurRadius: 10,
//       offset: Offset(3, 3),
//     ),
//   ];
//
//   List<BoxShadow> draft2 = [
//     // 内側
//     BoxShadow(
//       // color: Colors.brown.shade200,
//       color: Colors.green,
//       spreadRadius: 4,
//       blurRadius: 6,
//       offset: Offset(1.5, 1.5),
//     ),
//     // 左上
//     BoxShadow(
//       color: Colors.white.withValues(alpha: 0.8),
//       spreadRadius: 1,
//       blurRadius: 4,
//       offset: Offset(-3, -3),
//     ),
//     // 右下
//     BoxShadow(
//       // color: Colors.brown.shade200,
//       // color: Colors.green.withValues(alpha: 0.3),
//       color: Colors.black.withValues(alpha: 0.25),
//       spreadRadius: 1,
//       blurRadius: 10,
//       offset: Offset(3, 3),
//     ),
//   ];
// }
