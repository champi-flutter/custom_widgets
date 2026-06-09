import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/custom_widgets/buttons/template_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// ローディング表示をして、ローディング中のタップを制限するクラス
class LoadableWidget extends StatelessWidget {
  const LoadableWidget({
    super.key,
    required this.child,
    required this.childBorderRadius,
    required this.isLoading,
    this.diameter = 70,
    this.thickness = 8,
    this.circularColor = Colors.blue,
  });

  /// Widget の本体部分
  final Widget child;

  /// [child] と同じ [BorderRadius] を指定する必要がある。
  final BorderRadius childBorderRadius;

  /// ローディング中（ = タップ不可）かどうか
  final bool isLoading;

  /// 処理中...を表すぐるぐるの直径\
  /// デフォルトでは 70 。
  final double diameter;

  /// 処理中...を表すぐるぐるの線の太さ（[CircularProgressIndicator.strokeWidth]）\
  /// デフォルトでは 8 。
  final double thickness;

  /// 処理中...を表すぐるぐるの色\
  /// デフォルトでは、`Colors.blue` 。
  final Color circularColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: childBorderRadius,
      child: Stack(
        children: [
          // 本体
          child,
          // 処理中...
          if (isLoading) ...[
            // タップ遮断 + 背景を暗くする
            Positioned.fill(
              child: ModalBarrier(
                color: Colors.black.withValues(alpha: 0.4),
                // ローディング中に裏を触っても何も起きないようにする
                dismissible: false,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: diameter,
                  height: diameter,
                  child: CircularProgressIndicator(
                    color: circularColor,
                    strokeWidth: thickness,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 子Widgetのサイズ（レイアウト）が「無限」になってしまわないかを
/// 実際のレンダリングツリーの計測フェーズで安全にチェックするデバッグ用ガード
class SizeSafetyGuard extends SingleChildRenderObjectWidget {
  const SizeSafetyGuard({required Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeSafetyGuard();
  }
}

class _RenderSizeSafetyGuard extends RenderProxyBox {
  @override
  void performLayout() {
    // 1. まずは子Widgetのサイズ計算（レイアウト）を通常通り実行させる
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
      // 子Widgetが最終的に決定したサイズが「無限」になっていないか、
      // あるいは親からの制約が無限で、かつ子のサイズが想定外のサイズになっていないかを検証
      assert(!size.height.isInfinite && !size.width.isInfinite,
      "【LoadableWidget エラー】\n"
          "child が無限のサイズ（高さまたは横幅）を持とうとしています。\n"
          "ListView などの無限に広がる Widget を使用する場合は、\n"
          "LoadableWidget の外側を Expanded や SizedBox(height: 200) などで囲み、\n"
          "サイズ（高さを制限する制約）を明示的に与えてください。\n"
          "現在のサイズ: $size");
    } else {
      performResize();
    }
  }
}

class LoadableTemplateButton extends StatelessWidget {
  LoadableTemplateButton({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    required this.onPressed,
    this.isValid = true,
    required this.isLoading,
    BorderRadius? borderRadius,
    this.buttonWidth,
    this.buttonHeight,
    this.diameter = 70,
    this.thickness = 8,
    this.circularColor = Colors.white54,
    Color textColor = Colors.white,
    Color invalidTextColor = Colors.white,
  }):
        _borderRadius = borderRadius ?? BorderRadius.circular(35);

  /// ボタンの文字
  final String text;

  final double? fontSize;

  final FontWeight? fontWeight;

  /// ボタンが有効かどうか。
  final bool isValid;

  /// ボタンを押されたときの処理（[ButtonStyleButton.onPressed]）。
  final VoidCallback? onPressed;

  ///
  final BorderRadius _borderRadius;

  /// ボタンの横幅。デフォルトでは、```90.w```
  final double? buttonWidth;

  /// ボタンの縦幅。デフォルトでは、
  /// ``` _buttonWidth / 2  // 横幅の半分 ```
  final double? buttonHeight;

  /// ローディング中（ = タップ不可）かどうか
  final bool isLoading;

  /// 処理中...を表すぐるぐるの直径\
  /// デフォルトでは 70 。
  final double diameter;

  /// 処理中...を表すぐるぐるの線の太さ（[CircularProgressIndicator.strokeWidth]）\
  /// デフォルトでは 8 。
  final double thickness;

  /// 処理中...を表すぐるぐるの色\
  /// デフォルトでは、`Colors.blue` 。
  final Color circularColor;

  @override
  Widget build(BuildContext context) {
    return LoadableWidget(
      // 「アプリを始める」ボタン押下後の非同期処理中にタップを無効にする
      isLoading: isLoading,
      diameter: diameter,
      thickness: thickness,
      childBorderRadius: _borderRadius,
      circularColor: circularColor,
      child: TemplateButton(
        text: text,
        fontSize: fontSize,
        fontWeight: fontWeight,
        isValid: isValid,
        onPressed: onPressed,
        borderRadius: _borderRadius,
        buttonWidth: buttonWidth,
        buttonHeight: buttonHeight,
      ),
    );
  }
}

/// todo printメソッド [loadable_widget.dart]
void _print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[loadable_widget.dart]　" + s1);
    if (s2 != null) print("[loadable_widget.dart]　" + s2);
    if (s3 != null) print("[loadable_widget.dart]　" + s3);
    if (s4 != null) print("[loadable_widget.dart]　" + s4);
    if (s5 != null) print("[loadable_widget.dart]　" + s5);
    print("");
  }
}
