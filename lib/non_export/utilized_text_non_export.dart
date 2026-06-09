
import 'package:flutter/material.dart';
import 'package:custom_widgets/custom_widgets/texts/utilized_text.dart';

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

  @override
  double get designSide => 411.0; // ここでプロジェクト固有の基準サイズを指定
}