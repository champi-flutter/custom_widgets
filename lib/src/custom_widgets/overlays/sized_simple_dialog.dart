import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizedSimpleDialog extends StatelessWidget {
  const SizedSimpleDialog({
    super.key,
    this.occupancy = 0.96,
    this.title,
    required this.contentsList,
    this.customActionButtons,
    this.canDecide = true,
    required this.onDecided,
    this.decisionBackgroundColor = Colors.blue,
    this.invalidColor = const Color(0xFFE3F2FD), // Colors.blue.shade50
    this.decisionBorderColor = const Color(0xFF1976D2), // Colors.blue.shade700
    this.invalidBorderColor = const Color(0xFF42A5F5), // Colors.blue.shade400
    this.textColorOfDecision = Colors.white,
    this.invalidTextColor = Colors.white,
  }) : assert(
         occupancy > 0 && occupancy <= 1,
         "無効な値です（SizedSimpleDialog.occupancy）",
       ),
      assert(
        customActionButtons == null || onDecided == null,
        "customActionButtons を指定する場合、onDecided を明示的に null にしてください（SizedSimpleDialog）。",
      );

  /// 画面上のダイアログの占有率（ 0 〜 1 ）。　デフォルトでは、`0.96`
  final double occupancy;

  /// ダイアログのタイトル（nullable）。
  final Widget? title;

  /// ダイアログの中身
  final List<Widget> contentsList;

  /// 独自のアクションボタン。
  ///
  /// 独自のアクションボタンを指定する場合、[onDecided] を明示的に `null` にすること。
  final List<Widget>? customActionButtons;

  /// 決定ボタンが有効かどうか
  final bool canDecide;

  /// 決定ボタンを押したときの処理。
  final VoidCallback? onDecided;

  /// 決定ボタンが有効な時の背景色。デフォルトでは、```Colors.blue```
  final Color decisionBackgroundColor;

  /// 決定ボタンが無効な時の背景色。デフォルトでは、```Colors.blue.shade50```
  final Color invalidColor;

  /// 決定ボタンが有効な時の枠の色。デフォルトでは、```Colors.blue.shade700```
  final Color decisionBorderColor;

  /// 決定ボタンが無効な時の枠の色。デフォルトでは、```Colors.blue.shade400```
  final Color invalidBorderColor;

  /// 決定ボタンが有効な時の文字の色。デフォルトでは、```Colors.white```
  final Color textColorOfDecision;

  /// 決定ボタンが無効な時の文字の色。デフォルトでは、```Colors.white```
  final Color invalidTextColor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = context.screenWidth;
    return SimpleDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 4.r),
      title: title,
      children: [
        SizedBox(
          width: screenWidth * 0.96,
          child: Padding(
            padding: EdgeInsets.all(8.r),
            // キーボード出現などでダイアログサイズが無理やり変わる場合に対応
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 呼び出し元で指定する中身
                  ...contentsList,
                  // 決定ボタン（カード追加ダイアログ）
                  if (customActionButtons == null)
                    TemplateDialogActions(
                      canDecide: canDecide,
                      onDecided: onDecided,
                    )
                  else
                    ...customActionButtons!,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
