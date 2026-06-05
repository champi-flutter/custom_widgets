import 'package:flutter/material.dart';

/// ローディング表示をして、ローディング中のタップを制限するクラス
class LoadableWidget extends StatelessWidget {
  const LoadableWidget({
    super.key,
    required this.child,
    required this.isLoading,
    this.diameter = 70,
    this.thickness = 8,
    this.circularColor = Colors.blue,
  });

  /// Widget の本体部分
  final Widget child;

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
    return AbsorbPointer(
      absorbing: isLoading,
      child: Stack(
        children: [
          // 本体
          child,
          // 処理中...
          if (isLoading)
            Container(
              // 画面を少し暗くする
              color: Colors.black.withValues(alpha: 0.4),
              // 処理中...を表すぐるぐる
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
      ),
    );
  }
}
