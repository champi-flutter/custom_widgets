
import 'package:flutter/material.dart';

/// アクションを持つ Widget がない領域を、タップすると現在のフォーカスが外れる領域で埋める
/// ラッパークラス
class UnfocusTapScrimScope extends StatelessWidget {
  const UnfocusTapScrimScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 背景タップでフォーカスを解除する
        FocusManager.instance.primaryFocus?.unfocus();
        // FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
