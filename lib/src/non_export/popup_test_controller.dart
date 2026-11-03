
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopupTestController extends ChangeNotifier{
  Rect? _rect;

  Rect? get rect {
    if(_rect == null){
      return null;
    }
    return _rect!;
  }

  void setRect(Rect newRect){
    _print(
      "_rect != newRect : ${_rect != newRect}",
      "_rect == newRect : ${_rect == newRect}",
    );
    if(_rect != newRect) {
      _rect = newRect;
      notifyListeners();
    }
  }
}

/// printメソッド [PopupTestController ]
void _print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[PopupTestController ]　" + s1);
    if (s2 != null) print("[PopupTestController ]　" + s2);
    if (s3 != null) print("[PopupTestController ]　" + s3);
    if (s4 != null) print("[PopupTestController ]　" + s4);
    if (s5 != null) print("[PopupTestController ]　" + s5);
    print("");
  }
}