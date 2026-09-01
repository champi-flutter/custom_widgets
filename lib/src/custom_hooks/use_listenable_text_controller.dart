import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// [text] の変更時に、参照元スコープ全体をリビルドさせる [TextEditingController]
class ListenableTextController extends TextEditingController{
  ListenableTextController({super.text});
}

/// [text] の変更時に、参照元スコープ全体をリビルドさせる [TextEditingController]
/// を返すフック
ListenableTextController useListenableTextController({
  String text = '',
})
// 折りたたみ用
{
  // コントローラーを生成・保持
  final controller = useMemoized(()=>ListenableTextController(text: text), [text]);

  // Widget破棄時に自動dispose
  useEffect((){
    return controller.dispose;
  }, [controller]);

  // コントローラーの変更を監視し、値が変わるたびにこのフックを呼んでいるWidgetをリビルド
  useValueListenable(controller);

  // コントローラーを返す
  return controller;
}