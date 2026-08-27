import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/custom_widgets/buttons/custom_popup_menu_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum _RelativeRectTestWrapperStyle { toScreen, toChild }

/// [Rect] や [RelativeRect] の位置を確認するラッパークラス
///
/// container （基準となる外側の枠）となる Widget にラップする。
///
/// [Rect] の絶対位置を調べたい場合は、[RelativeRectTestWrapper.toScreen]
/// で呼び出す。
class RelativeRectTestWrapper extends HookWidget {
  /// [Rect] の絶対位置（ = 画面全体を基準とした [RelativeRect] ）の場合のコンストラクタ
  const RelativeRectTestWrapper.toScreen({
    super.key,
    required Widget screen,
    required this.rect,
    this.isValid = true,
    this.dashedLineStyle = DashedLineStyle.quadrants,
    this.rectAreaDashedLineColor = Colors.indigoAccent,
    this.rectAreaColor = Colors.red,
    this.containerAreaColor = Colors.green,
    this.centroidColor = Colors.cyan,
    this.containerCentroidColor,
    this.containerDashedLineColor = const Color(0xfffbc02d),
    this.topSideMarker,
    this.leftSideMarker,
  }) : _style = _RelativeRectTestWrapperStyle.toScreen,
       child = screen;

  const RelativeRectTestWrapper({
    super.key,
    required this.child,
    required this.rect,
    this.isValid = true,
    this.dashedLineStyle = DashedLineStyle.quadrants,
    this.rectAreaDashedLineColor = Colors.yellow,
    this.rectAreaColor = Colors.red,
    this.containerAreaColor = Colors.green,
    this.centroidColor = Colors.cyan,
    this.containerCentroidColor,
    this.containerDashedLineColor = const Color(0xfffbc02d),
    this.topSideMarker,
    this.leftSideMarker,
  }) : _style = _RelativeRectTestWrapperStyle.toChild;

  final _RelativeRectTestWrapperStyle _style;

  /// 波線のスタイル。　デフォルトでは、対象の中心で交わる縦と横の線。
  final DashedLineStyle dashedLineStyle;

  /// 対象の [Rect] 。 nullable で、呼び出し元で操作する。
  final Rect? rect;

  final Widget child;

  /// このクラスによる描画を有効にするかどうか。 デフォルトでは、`true` 。
  final bool isValid;

  /// 対象 の領域の色。
  final Color rectAreaColor;

  /// container の領域の色。
  final Color containerAreaColor;

  /// 対象の重心の色。
  final Color centroidColor;

  /// container の重心の色。　指定がない場合は、 [centroidColor] と同じになる。
  final Color? containerCentroidColor;

  /// 波線の色。
  final Color rectAreaDashedLineColor;

  /// container の波線の色。　指定がない場合は、[dashedLineColor] と同じになる。
  final Color containerDashedLineColor;

  /// 対象 [Rect] の左辺を別の色にして、左辺と右辺が逆転していないかを調べる。
  final Color? leftSideMarker;

  /// 対象 [Rect] の上辺を別の色にして、上辺と下辺が逆転していないかを調べる。
  final Color? topSideMarker;

  @override
  Widget build(BuildContext context) {
    final container = useState<Rect?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (_style) {
          // 指定の子Widget の範囲を container とする場合
          case _RelativeRectTestWrapperStyle.toChild:
            Element? childElement;

            // 直下の子要素を探索
            context.visitChildElements((element) {
              childElement = element;
            });

            assert(childElement != null, "子Widget の BuildContext が見つかりません。");

            // container を取得してリビルド
            container.value = childElement!.getWidgetRect();
          // 画面全体を container とする場合
          case _RelativeRectTestWrapperStyle.toScreen:
            container.value = Offset.zero & context.screenSize;
        }
      });
      return null;
    }, []);

    final CustomPainter? containerPainter = container.value != null
        ? switch (dashedLineStyle) {
            DashedLineStyle.quadrants => TestRectPainter.quadrants(
              rect: container.value!,
              areaColor: containerAreaColor,
              centroidColor: containerCentroidColor ?? centroidColor,
              alpha: 0.1,
              dashedLineColor: containerDashedLineColor,
            ),
            DashedLineStyle.diagonal => TestRectPainter.diagonal(
              rect: container.value!,
              areaColor: containerAreaColor,
              centroidColor: containerCentroidColor ?? centroidColor,
              alpha: 0.1,
              dashedLineColor: containerDashedLineColor,
            ),
            DashedLineStyle.none => TestRectPainter(
              rect: container.value!,
              areaColor: containerAreaColor,
              centroidColor: containerCentroidColor ?? centroidColor,
              alpha: 0.1,
              dashedLineColor: containerDashedLineColor,
            ),
          }
        : null;

    final CustomPainter? rectPainter = rect != null
        ? switch (dashedLineStyle) {
            DashedLineStyle.quadrants => TestRectPainter.quadrants(
              rect: rect!,
              areaColor: rectAreaColor,
              centroidColor: centroidColor,
              dashedLineColor: rectAreaDashedLineColor,
              topSideMarker: topSideMarker,
              leftSideMarker: leftSideMarker,
            ),
            DashedLineStyle.diagonal => TestRectPainter.diagonal(
              rect: rect!,
              areaColor: rectAreaColor,
              centroidColor: centroidColor,
              dashedLineColor: rectAreaDashedLineColor,
              topSideMarker: topSideMarker,
              leftSideMarker: leftSideMarker,
            ),
            DashedLineStyle.none => TestRectPainter(
              rect: rect!,
              areaColor: rectAreaColor,
              centroidColor: centroidColor,
              dashedLineColor: rectAreaDashedLineColor,
              topSideMarker: topSideMarker,
              leftSideMarker: leftSideMarker,
            ),
          }
        : null;

    return Stack(
      children: [
        child,
        // container の範囲の描画
        if (isValid && container.value != null)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: containerPainter,
                size: Size.infinite,
                isComplex: false,
                willChange: false,
              ),
            ),
          ),
        // rect の範囲の描画
        if (isValid && rect != null)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: rectPainter,
                size: Size.infinite,
                isComplex: false,
                willChange: false,
              ),
            ),
          ),
      ],
    );
  }
}

enum DashedLineStyle { none, diagonal, quadrants }

class TestRectPainter extends CustomPainter {
  final Rect rect;

  /// 枠とその中の色。 中の塗りつぶしは、[alpha] で薄くする。
  final Color areaColor;

  // final Color borderColor;

  /// 対象の塗りつぶしの具合。0〜1で、0が塗りつぶしなし、1が完全に塗りつぶす。
  final double alpha;

  /// 対象の重心の色
  final Color centroidColor;

  /// 波線の色
  final Color dashedLineColor;

  /// 対象 [Rect] の左辺を別の色にして、左辺と右辺が逆転していないかを調べる。
  final Color? leftSideMarker;

  /// 対象 [Rect] の上辺を別の色にして、上辺と下辺が逆転していないかを調べる。
  final Color? topSideMarker;

  final DashedLineStyle _dashedLineStyle;

  const TestRectPainter({
    required this.rect,
    this.areaColor = Colors.red,
    // this.borderColor = Colors.red,
    this.alpha = 0.3,
    this.centroidColor = Colors.cyan,
    this.dashedLineColor = Colors.orange,
    this.leftSideMarker,
    this.topSideMarker,
  }) : assert(alpha >= 0 && alpha <= 1, "alpha 値が無効です。（RectDiagonalPainter）"),
       _dashedLineStyle = DashedLineStyle.none;

  const TestRectPainter.diagonal({
    required this.rect,
    this.areaColor = Colors.red,
    // this.borderColor = Colors.red,
    this.alpha = 0.3,
    this.centroidColor = Colors.cyan,
    this.dashedLineColor = Colors.orange,
    this.leftSideMarker,
    this.topSideMarker,
  }) : assert(alpha >= 0 && alpha <= 1, "alpha 値が無効です。（RectDiagonalPainter）"),
       _dashedLineStyle = DashedLineStyle.diagonal;

  const TestRectPainter.quadrants({
    required this.rect,
    this.areaColor = Colors.red,
    // this.borderColor = Colors.red,
    this.alpha = 0.3,
    this.centroidColor = Colors.cyan,
    this.dashedLineColor = Colors.orange,
    this.leftSideMarker,
    this.topSideMarker,
  }) : assert(alpha >= 0 && alpha <= 1, "alpha 値が無効です。（RectDiagonalPainter）"),
       _dashedLineStyle = DashedLineStyle.quadrants;

  @override
  void paint(Canvas canvas, Size size) {
    // Rect（範囲）を描画
    final rectPaint = Paint()
      ..color = areaColor.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    final rectBorderPaint = Paint()
      ..color = areaColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(rect, rectPaint);
    canvas.drawRect(rect, rectBorderPaint);

    // 重心（中心点）を描画
    final Offset centroid = rect.center;
    final centroidPaint = Paint()
      ..color = centroidColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const double crossSize = 10.0;
    canvas.drawLine(
      Offset(centroid.dx - crossSize, centroid.dy),
      Offset(centroid.dx + crossSize, centroid.dy),
      centroidPaint,
    );
    canvas.drawLine(
      Offset(centroid.dx, centroid.dy - crossSize),
      Offset(centroid.dx, centroid.dy + crossSize),
      centroidPaint,
    );

    // 矩形の4隅の座標
    final Offset tl = rect.topLeft;
    final Offset tr = rect.topRight;
    final Offset bl = rect.bottomLeft;
    final Offset br = rect.bottomRight;
    final Offset cl = rect.centerLeft;
    final Offset tc = rect.topCenter;
    final Offset cr = rect.centerRight;
    final Offset bc = rect.bottomCenter;

    final dashedLinePaint = Paint()
      ..color = dashedLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    switch (_dashedLineStyle) {
      // 対角線を描画
      case DashedLineStyle.diagonal:
        // 対角線A: 左上から右下 (TopLeft -> BottomRight)
        drawDashedLine(canvas, tl, br, dashedLinePaint);
        // 対角線B: 右上から左下 (TopRight -> BottomLeft)
        drawDashedLine(canvas, tr, bl, dashedLinePaint);
      // 座標軸を描画
      case DashedLineStyle.quadrants:
        // x軸
        drawDashedLine(canvas, cl, cr, dashedLinePaint);
        // y軸
        drawDashedLine(canvas, tc, bc, dashedLinePaint);

      case DashedLineStyle.none:
        break;
    }

    // 左辺のマーカーが指定されている場合
    if(leftSideMarker != null){

      final leftSidePaint = Paint()
        ..color = leftSideMarker!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(tl, bl, leftSidePaint);
    }

    // 上辺のマーカーが指定されている場合
    if(topSideMarker != null){

      final topSidePaint = Paint()
        ..color = topSideMarker!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(tl, tr, topSidePaint);
    }
  }

  // 破線を描画するヘルパー関数
  void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const double dashWidth = 5.0; // 線の長さ
    const double dashSpace = 3.0; // 間隔

    final Offset distance = end - start;
    final double totalLength = distance.distance;
    final Offset unitDirection = distance / totalLength;

    double currentLength = 0;
    while (currentLength < totalLength) {
      final Offset dashStart = start + unitDirection * currentLength;
      final Offset dashEnd =
          start + unitDirection * (currentLength + dashWidth);

      // 最後の線がはみ出さないように調整
      final Offset effectiveDashEnd = (dashEnd - start).distance > totalLength
          ? end
          : dashEnd;

      canvas.drawLine(dashStart, effectiveDashEnd, paint);
      currentLength += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant TestRectPainter oldDelegate) {
    return oldDelegate.rect != rect;
  }
}

/// printメソッド [RelativeRectTestWrapper]
void _print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[RelativeRectTestWrapper]　" + s1);
    if (s2 != null) print("[RelativeRectTestWrapper]　" + s2);
    if (s3 != null) print("[RelativeRectTestWrapper]　" + s3);
    if (s4 != null) print("[RelativeRectTestWrapper]　" + s4);
    if (s5 != null) print("[RelativeRectTestWrapper]　" + s5);
    print("");
  }
}
