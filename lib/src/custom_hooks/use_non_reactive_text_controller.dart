


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// [text] の変更を反映させない [TextEditingController]
class NonReactiveTextController extends TextEditingController{
  NonReactiveTextController({super.text});
}

/// [text] の変更を反映させない [TextEditingController] を返すフック
///
/// [useTextEditingController] 同様、TextFieldの入力値の変更によるスコープ全体の
/// リビルドを行わない。
NonReactiveTextController useNonReactiveTextController({
  String text = '',
})
// 折りたたみ用
{
  // コントローラーを生成・保持
  final controller = useMemoized(()=>NonReactiveTextController(text: text));

  // Widget破棄時に自動dispose
  useEffect((){
    return controller.dispose;
  }, [controller]);

  // コントローラーを返す
  return controller;
}