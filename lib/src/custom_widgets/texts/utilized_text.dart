import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/extensions/extensions_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// /// [ScreenUtil] と [FittedBox] を用いた [Text] クラス
// class UtilizedText extends StatelessWidget {
//
//   /// 文字本体
//   final String data;
//   final double fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//
//   /// [FittedBox.fit]。
//   ///
//   /// 文字サイズが、Widget サイズよりも大きくなる際の、調整のしかた。デフォルトは、
//   /// [BoxFit.scaleDown] 。
//   final BoxFit fit;
//
//   /// テキストの配置。\
//   /// デフォルトでは、左揃え。
//   final AlignmentGeometry alignment;
//
//   const UtilizedText(
//       this.data, {
//         super.key,
//         this.fontSize = 21,
//         this.fit = BoxFit.scaleDown,
//         this.color,
//         this.fontWeight,
//         this.alignment = AlignmentGeometry.centerLeft,
//       });
//
//   @override
//   Widget build(BuildContext context) {
//     return FittedBox(
//       fit: fit,
//       alignment: alignment,
//       child: Text(
//         data,
//         style: TextStyle(
//           fontSize: fontSize.sp, // ここで初めて sp を計算する
//           color: color,
//           fontWeight: fontWeight,
//         ),
//       ),
//     );
//   }
// }

/// [ScreenUtil] と [FittedBox] を用いた [Text] クラス
///
/// 使用元で、[designSide]（デバッグ時に参照するデバイスの短辺）を指定して実装すること。
///
/// 実装例（デザイン基準サイズ `Size(411, 914)`（短辺 411）を想定）
/// ```
/// class UtilizedText extends CustomTextUtilizer {
///   const UtilizedText(
///       super.data, {
///         super.key,
///         super.fontSize = 21,
///         super.fit = BoxFit.scaleDown,
///         super.color,
///         super.fontWeight,
///         super.alignment = Alignment.centerLeft,
///       });
///
///   @override
///   double get designSide => 411.0; // ここでプロジェクト固有の基準サイズを指定
/// }
/// ```
///
abstract class CustomTextUtilizer extends StatelessWidget {
  /// 文字本体
  final String data;

  /// 基準とするフォントサイズ（単位: dp/sp 相当）
  final double fontSize;

  /// 文字色
  final Color? color;

  /// フォントの太さ
  final FontWeight? fontWeight;

  /// [FittedBox.fit]
  /// 文字サイズが、Widget サイズよりも大きくなる際の調整方法。
  /// デフォルトは [BoxFit.scaleDown]。
  final BoxFit fit;

  /// テキストの配置。
  /// デフォルトは [Alignment.centerLeft]。
  final AlignmentGeometry alignment;

  /// デバッグ時に参照するデバイスの短辺
  double get designSide;

  const CustomTextUtilizer(
      this.data, {
        super.key,
        required this.fontSize,
        this.fit = BoxFit.scaleDown,
        this.color,
        this.fontWeight,
        this.alignment = Alignment.centerLeft,
      });

  @override
  Widget build(BuildContext context) {
    // 実際に使用しているデバイスの短辺を context から取得
    final double actualSide = context.screenSize.shortestSide;

    // 実際に使用しているデバイスの短辺 ÷ デバッグ時に参照するデバイスの短辺
    final double scale = actualSide / designSide;

    // テキストスケールを適用
    final double adjustedSize = MediaQuery.textScalerOf(context).scale(fontSize * scale);

    return FittedBox(
      fit: fit,
      alignment: alignment,
      child: Text(
        data,
        style: TextStyle(
          fontSize: adjustedSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
