import 'package:flutter/material.dart';

extension NavigatorExtensions on NavigatorState{
  /// フォーカスを解除してから次の画面を `push` する。
  ///
  /// [pop] 時に値を受け取りたい場合は、`await` すること。
  Future<T?> pushWithUnfocus<T extends Object?>(Route<T> route) async {
    // NavigatorStateのcontextを使ってフォーカスを解除
    FocusScope.of(context).unfocus();

    // 次の画面へ遷移
    return await push(route);
  }
  /// フォーカスを解除してから画面を閉じる
  void popWithUnfocus<T>([T? result]) {
    // NavigatorStateのcontextを使ってフォーカスを解除
    FocusScope.of(context).unfocus();

    // 画面を閉じる
    pop(result);
  }
}