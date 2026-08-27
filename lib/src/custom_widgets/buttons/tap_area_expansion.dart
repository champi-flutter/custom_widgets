import 'package:flutter/material.dart';

/// ボタン（[button]）のタップ範囲を [Row] の子Widget 全体に広げるクラス
class TapAreaExpandingRow extends StatelessWidget {
  const TapAreaExpandingRow({
    super.key,
    required this.button,
    required this.leftSideContents,
    required this.rightSideContents,
    required this.onTap,
    this.entirePadding = const EdgeInsets.all(4.0),
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 4.0),
  });

  final Widget button;

  /// ボタンの左側に配置するコンテンツ
  final List<Widget> leftSideContents;

  /// ボタンの右側に配置するコンテンツ
  final List<Widget> rightSideContents;

  /// タップイベント
  final VoidCallback onTap;

  /// この widget 全体の padding
  ///
  /// デフォルトでは、`EdgeInsets.all(4.0)` 。
  final EdgeInsetsGeometry entirePadding;

  /// ボタンの padding
  ///
  /// デフォルトでは、`EdgeInsets.symmetric(horizontal: 4.0)` 。
  final EdgeInsetsGeometry buttonPadding;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: entirePadding,
        child: Row(
          children: [
            ...leftSideContents,
            Padding(
              padding: buttonPadding,
              child: IgnorePointer(child: button),
            ),
            ...rightSideContents,
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
