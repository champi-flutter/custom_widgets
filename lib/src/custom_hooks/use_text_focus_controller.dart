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
TextFocusController useTextFocusController({
  String? text,
  required void Function({required String textSnapshot}) onUnfocused,
})
// 折りたたみ用
{
  final focusNode = useFocusNode();
  final controller = useTextEditingController(text: text);

  useEffect(() {
    // フォーカスの状態が変更する際に呼ばれるリスナー
    void handleFocusChange() {
      if (!focusNode.hasFocus) {
        onUnfocused(textSnapshot: controller.text);
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