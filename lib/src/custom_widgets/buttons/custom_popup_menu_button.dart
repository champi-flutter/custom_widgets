import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/non_export/popup_test_controller.dart';
import 'package:custom_widgets/src/non_export/private_scaler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomPopupMenuButton<T> extends StatelessWidget {
  const CustomPopupMenuButton({
    super.key,
    required this.child,
    required this.menuItems,
    this.menuWidth = 150,
    this.viewPoint,
  }): assert(
    viewPoint ==null || (viewPoint > 0 && viewPoint <= 1),
    "無効な値です。（CustomPopupMenuButton.viewPoint）",
  );

  final List<PopupMenuEntry<T>> menuItems;

  /// popup メニューの横幅。　デフォルトでは、`150` 。
  final double menuWidth;

  /// ボタンの形を決める子Widget
  ///
  /// `onTap` や `onPressed` などのタップイベントを持つクラスであっても、それらのイベント
  /// は無視され、形のみが参照される。
  final Widget child;

  // todo 0〜0.5 の場合（2026/07/08）＞＞
  final double? viewPoint;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: IgnorePointer(child: child),
      onTap: () {
        if(viewPoint == null) {
          showMenuFromWidgetRect(
            context,
            menuItems: menuItems,
            menuWidth: menuWidth,
            leftSideShift: 1,
            rightSideShift: 0,
          );
        } else if (viewPoint! > 0.5){
          showMenuFromWidgetRectAtPointOf(
            viewPoint!,
            context,
            menuItems: menuItems,
          );
        }
      },
    );
  }
}

/// [BuildContext] から Widget のレンダリング情報を取得する拡張メソッド
extension renderingWidgetInfo on BuildContext {
  /// 自身のRect取得メソッド
  ///
  /// [leftSideShift] は、対象 [Rect] の左辺の移動値、[rightSideShift] は、右辺の移動値。
  /// **ともに右方向か正、左方向が負。**
  Rect getWidgetRect({
    double leftSideShift = 0,
    double rightSideShift = 0,
    Offset adjustingOffset = Offset.zero,
  })
  // 折りたたみ用
  {
    assert(
      findRenderObject() != null,
      "この BuildContext は Widget の情報を持ちません。（getWidgetRect）",
    );
    _print("context.findRenderObject() = ${findRenderObject()}");
    // 自身のレンダリング情報を取得
    final RenderBox renderBox = findRenderObject() as RenderBox;

    // 自身のサイズを取得
    final Size preSize = renderBox.size;

    // 自身（の左上）のグローバルな位置
    final Offset preOffset = renderBox.localToGlobal(Offset.zero);
    // Offsetを各引数で調整
    final dx = preOffset.dx + leftSideShift + adjustingOffset.dx;
    final dy = preOffset.dy + adjustingOffset.dy;
    final Offset offset = Offset(dx, dy);
    final width =
        preSize.width - leftSideShift - adjustingOffset.dx + rightSideShift;
    final height = preSize.height - adjustingOffset.dy;
    final Size size = Size(width, height);
    // 自身の情報をRectクラスに落とし込む
    final Rect widgetRect = offset & size;
    if (kDebugMode) {
      // final Offset o = Offset(offset.dx, offset.dy - 106.2857);
      _print(
        "自身のRect取得メソッド: offset = $offset",
        "自身のRect取得メソッド: size = $size",
        "自身のRect取得メソッド: widgetRect = $widgetRect",
        // "AppBarを考慮 => ${o & size}",
      );
    }
    return widgetRect;
  }

  /// 自身のRect取得メソッド
  ///
  /// [leftSideShift] は、対象 [Rect] の左辺の移動値、[rightSideShift] は、右辺の移動値。
  /// **ともに右方向か正、左方向が負。**
  Rect zoomWidgetRect({
    double widthRatio = 1,
    double heightRatio = 1,
  })
  // 折りたたみ用
  {
    assert(
    widthRatio > 0 && widthRatio <= 1,
      "無効な値です。（context.zoomWidgetRect）",
    );
    assert(
    heightRatio > 0 && heightRatio <= 1,
    "無効な値です。（context.zoomWidgetRect）",
    );
    assert(
    findRenderObject() != null,
    "この BuildContext は Widget の情報を持ちません。（getWidgetRect）",
    );
    _print("context.findRenderObject() = ${findRenderObject()}");
    // 自身のレンダリング情報を取得
    final RenderBox renderBox = findRenderObject() as RenderBox;

    // 自身のサイズを取得
    final Size preSize = renderBox.size;

    // 両端の変化値
    final double verticalShift = preSize.height * widthRatio * 0.5;

    // 両端の変化値
    final double horizontalShift = preSize.width * widthRatio * 0.5;

    // 自身（の左上）のグローバルな位置
    final Offset preOffset = renderBox.localToGlobal(Offset.zero);
    // Offset（左上）を調整
    final dx = preOffset.dx + horizontalShift;
    final dy = preOffset.dy + verticalShift;
    final Offset offset = Offset(dx, dy);
    final width = preSize.width * widthRatio;
    final height = preSize.height * heightRatio;
    final Size size = Size(width, height);
    // 自身の情報をRectクラスに落とし込む
    final Rect targetRect = offset & size;
    if (kDebugMode) {
      _print(
        "自身のRect取得メソッド: offset = $offset",
        "自身のRect取得メソッド: size = $size",
        "自身のRect取得メソッド: targetRect = $targetRect",
      );
    }
    return targetRect;
  }
}

/// Widget の情報から popup メニューを表示するメソッド
///
/// メニュー表示位置は、タップされる Widget の [Rect]の情報（位置やサイズなど）で決まり、
/// タップ位置に依存しない。
///
/// 対象 [Rect] の中心が、画面の中心より **左側** の時、 **メニューの左辺が対象 [Rect]
/// の左辺に沿うように** 表示される。
///
/// 対象 [Rect] の中心が、画面の中心より **右側** の時、 **メニューの右辺が対象 [Rect]
/// の右辺に沿うように** 表示される。
///
/// [leftSideShift] は、対象 [Rect] の左辺の移動値、[rightSideShift] は、右辺の移動値。
/// **ともに右方向か正、左方向が負。**
///
/// [leftSideShift] が正方向に十分大きい場合や、 [rightSideShift] が負方向に十分大きい
/// 場合には、対象 [Rect] の左辺と右辺は逆転しうる。
Future<T?> showMenuFromWidgetRect<T>(
  BuildContext context, {
  required List<PopupMenuEntry<T>> menuItems,
  double menuWidth = 100,
  double leftSideShift = 1,
  double rightSideShift = 0,
  Offset adjustingOffset = const Offset(0, 0),
})
// 折りたたみ用
async {
  // 自身の情報をRectクラスに落とし込む
  final widgetRect = context.getWidgetRect(
    leftSideShift: leftSideShift.pWidth(context),
    rightSideShift: rightSideShift.pWidth(context),
    adjustingOffset: adjustingOffset,
  );
  _print("widgetRect = $widgetRect");

  if (kDebugMode) {
    // エミュレータに widgetRect の範囲を表示
    context.read<PopupTestController>().setRect(widgetRect);
  }

  // 画面全体のRect
  final Rect screenRect = Offset.zero & context.screenSize;
  return await showMenu<T>(
    context: context,
    // showMenuPositionメソッド呼び出し
    position: popUpRect(focusRect: widgetRect, screenRect: screenRect),
    // メニューの横幅を固定
    constraints: BoxConstraints.tightFor(width: menuWidth.pr(context)),
    // Popupメニュー
    items: menuItems,
  );
}

/// popup メニューの position を作るメソッド
RelativeRect popUpRect({
  double? dx,
  double? dy,
  double shift = 0,
  Rect? focusRect,
  Rect? screenRect,
})
// 折りたたみ用
{
  // 位置から作る
  final bool buildsFromCoordinates = dx != null && dy != null;

  // Rectから作る
  final bool buildsFromRect = focusRect != null && screenRect != null;

  assert(
    buildsFromCoordinates || buildsFromRect,
    "エラー: popUpRect()の引数が不足しています。",
  );

  // 位置から作る
  if (buildsFromCoordinates) {
    return RelativeRect.fromLTRB(dx + shift, dy + shift, dx, dy);
  }
  // Rectから作る
  else if (focusRect != null && screenRect != null) {
    return RelativeRect.fromRect(focusRect, screenRect);
  }
  // assert でエラーを返す（網羅性のための仮の記述）
  else {
    return RelativeRect.fromLTRB(0, 0, 0, 0);
  }
}

/// 対象 Widget の固有の地点に popup メニューを表示するメソッド
///
/// 対象 Widget の上辺に対して、[x]:(1-[x]) の地点に popup メニューの左上を合わせる。
Future<T?> showMenuFromWidgetRectAtPointOf<T>(
    double x,
  BuildContext context, {
  required List<PopupMenuEntry<T>> menuItems,
  double menuWidth = 100,
})
// 折りたたみ用
async {
  // 自身の情報をRectクラスに落とし込む
  final targetRect = context.zoomWidgetRect(
    widthRatio: x,
  );
  _print("targetRect = $targetRect");

  if (kDebugMode) {
    // エミュレータに widgetRect の範囲を表示
    context.read<PopupTestController>().setRect(targetRect);
  }

  // 画面全体のRect
  final Rect screenRect = Offset.zero & context.screenSize;
  return await showMenu<T>(
    context: context,
    // showMenuPositionメソッド呼び出し
    position: popUpRect(focusRect: targetRect, screenRect: screenRect),
    // メニューの横幅を固定
    constraints: BoxConstraints.tightFor(width: menuWidth.pr(context)),
    // Popupメニュー
    items: menuItems,
  );
}

/// printメソッド [CustomPopupMenuButton]
void _print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[CustomPopupMenuButton]　" + s1);
    if (s2 != null) print("[CustomPopupMenuButton]　" + s2);
    if (s3 != null) print("[CustomPopupMenuButton]　" + s3);
    if (s4 != null) print("[CustomPopupMenuButton]　" + s4);
    if (s5 != null) print("[CustomPopupMenuButton]　" + s5);
    print("");
  }
}
