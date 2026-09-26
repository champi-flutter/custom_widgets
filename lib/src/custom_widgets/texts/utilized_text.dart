import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/extensions/extensions_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [UtilizedText] の初期値の設定
class TextUtilizerDefault {
  const TextUtilizerDefault({
    required this.fontSize,
    required this.designSide,
    this.textColor,
    this.fontWeight,
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.centerLeft,
  });

  /// 基準とするフォントサイズ（単位: dp/sp 相当）
  final double fontSize;

  /// 文字色
  final Color? textColor;

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
  final double designSide;
}

/// アプリ全体の [UtilizedText] の初期値の設定（[TextUtilizerDefault]）を届けるクラス
class TextUtilizerScope extends InheritedWidget {
  final TextUtilizerDefault defaultInfo;

  const TextUtilizerScope({
    super.key,
    required this.defaultInfo,
    required super.child,
  });

  static TextUtilizerDefault of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<
        TextUtilizerScope>();
    // Scopeが指定されていない場合のセーフティガード（必要に応じてデフォルト値を指定）
    assert(
    scope != null,
    'TextUtilizerScope がツリー上に見つかりません。TextUtilizerScope でアプリをラップしてください。',
    );
    return scope!.defaultInfo;
  }

  static TextUtilizerDefault? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TextUtilizerScope>()
        ?.defaultInfo;
  }

  @override
  bool updateShouldNotify(TextUtilizerScope oldWidget) {
    return defaultInfo != oldWidget.defaultInfo;
  }
}

/// [ScreenUtil] と [FittedBox] を用いた [Text] クラス
///
/// アプリのルート（`main.dart` など）で [TextUtilizerScope] を用いて
/// [TextUtilizerDefault] を設定すること。
///
/// ### 実装例（`main.dart` での初期設定）
/// ```dart
/// void main() {
///   runApp(
///     const TextUtilizerScope(
///       defaultInfo: TextUtilizerDefault(
///         designSide: 411.0, // プロジェクトのデザイン基準とするデバイス短辺
///         fontSize: 21.0,    // UtilizedText 呼び出し時のデフォルトフォントサイズ
///         // その他デフォルト値を設定したい場合
///         textColor: Colors.black,
///       ),
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// ### 使用例（各画面での利用）
/// ```dart
///        child: UtilizedText(
///          "テキスト",
///          fontSize: 21,
///          color: textColor ?? Theme.of(context).colorScheme.onPrimary,
///        ),
/// ```
class UtilizedText extends StatelessWidget {
  /// 文字本体
  final String data;

  /// 基準とするフォントサイズ（単位: dp/sp 相当）
  final double? defaultFontSize;

  /// 文字色
  final Color? defaultTextColor;

  /// フォントの太さ
  final FontWeight? defaultFontWeight;

  /// [FittedBox.fit]
  /// 文字サイズが、Widget サイズよりも大きくなる際の調整方法。
  /// デフォルトは [BoxFit.scaleDown]。
  final BoxFit? defaultBoxFit;

  /// テキストの配置。
  /// デフォルトは [Alignment.centerLeft]。
  final AlignmentGeometry? defaultAlignment;

  const UtilizedText(
      this.data, {
    super.key,
    double? fontSize,
    BoxFit? fit,
    Color? color,
    FontWeight? fontWeight,
    AlignmentGeometry? alignment,
  })
      : defaultFontSize = fontSize,
        defaultBoxFit = fit,
        defaultTextColor = color,
        defaultFontWeight = fontWeight,
        defaultAlignment = alignment;

  @override
  Widget build(BuildContext context) {
    // ツリーの上位から設定を取得する（未ラップ時のデフォルト値も考慮）
    final defaultInfo = TextUtilizerScope.maybeOf(context) ??
        const TextUtilizerDefault(designSide: 411.0, fontSize: 21,);

    // ウィジェット個別指定の値 ＞ Scopeで設定された値
    final fontSize = defaultFontSize ?? defaultInfo.fontSize;
    final textColor = defaultTextColor ?? defaultInfo.textColor;
    final fontWeight = defaultFontWeight ?? defaultInfo.fontWeight;
    final fit = defaultBoxFit ?? defaultInfo.fit;
    final alignment = defaultAlignment ?? defaultInfo.alignment;

    // デバッグ時に参照するデバイスの短辺
    final double designSide = defaultInfo.designSide;

    // 実際に使用しているデバイスの短辺を context から取得
    final double actualSide = context.screenSize.shortestSide;

    // 実際に使用しているデバイスの短辺 ÷ デバッグ時に参照するデバイスの短辺
    final double scale = actualSide / designSide;

    // テキストスケールを適用
    final double adjustedSize = MediaQuery.textScalerOf(
      context,
    ).scale(fontSize* scale);

    return FittedBox(
      fit: fit,
      alignment: alignment,
      child: Text(
        data,
        style: TextStyle(
          fontSize: adjustedSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
