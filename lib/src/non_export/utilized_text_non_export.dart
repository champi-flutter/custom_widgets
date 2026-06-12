
import 'package:custom_widgets/src/custom_widgets/texts/utilized_text.dart';
import 'package:flutter/material.dart';

class UtilizedText extends CustomTextUtilizer {
  const UtilizedText(
      super.data, {
        super.key,
        super.fontSize = 21, // プロジェクト独自のデフォルト値を設定可能
        super.fit = BoxFit.scaleDown,
        super.color,
        super.fontWeight,
        super.alignment = Alignment.centerLeft,
      });

  /// Google Pixel 8 の横幅
  @override
  double get designSide => 411.0;
}