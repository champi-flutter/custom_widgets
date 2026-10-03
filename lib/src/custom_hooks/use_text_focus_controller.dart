import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// FocusNode と TextEditingController を保持するクラス
class TextFocusController {
  const TextFocusController({
    required this.focusNode,
    required this.controller,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
}

/// フォーカス解除時に指定した処理を実行する TextField 用カスタムフック
///
///  - [onUnfocused]: このコントローラのフォーカスが外れたときの処理
///
/// 対象 [TextField] の `onTapOutside` を、以下のように記述すること。
/// ```
///    return TextField(
///      // この領域の「外」がタップされたらフォーカスを外す
///      onTapOutside: (event) {
///        textFocusController.focusNode.unfocus();
///      },
///      controller: textFocusController.controller,
///      style: TextStyle(fontSize: 17.0.sp),
///      // エンターキー等で、入力完了によってフォーカスが外れるようにする
///      onSubmitted: (_) {
///        textFocusController.focusNode.unfocus();
///      },
///      // 入力欄に文字を入力したときに、編集未保存フラグを立てる。
///      onChanged: (String value) {
///        // ...
///      },
///    );
/// ```
TextFocusController useTextFocusController({
  String? text,
  required void Function(String textSnapshot) onUnfocused,
})
// 折りたたみ用
{
  final focusNode = useFocusNode();
  final controller = useTextEditingController(text: text);

  useEffect(() {
    // フォーカスの状態が変更する際に呼ばれるリスナー
    void handleFocusChange() {
      if (!focusNode.hasFocus) {
        onUnfocused(controller.text);
      }
    }

    // リスナーを登録
    focusNode.addListener(handleFocusChange);
    // リスナーを破棄（クリーンアップ）
    return () => focusNode.removeListener(handleFocusChange);
  }, [focusNode, onUnfocused]);

  return TextFocusController(
    focusNode: focusNode,
    controller: controller,
  );
}