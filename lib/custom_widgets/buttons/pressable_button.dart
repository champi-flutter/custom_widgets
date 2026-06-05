import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 押し込むアニメーションがあるボタン。
class PressableButton extends HookWidget {
  const PressableButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.color = Colors.blue,
    this.isWrapped = false,
    this.borderRadius = 6.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    this.border,
    required this.height,
    required this.width,
    this.minHeight = 50,
    this.minWidth = 100,
    this.shadowColor = Colors.black38,
    this.behaviorOnTransparentArea = HitTestBehavior.opaque,
    this.alignment = Alignment.center,
    this.boxFit = BoxFit.scaleDown,
  });

  final VoidCallback? onPressed;
  final Function(LongPressStartDetails)? onLongPressStart;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final Widget child;
  final bool isWrapped;

  /// ボタンの色（nullable）。デフォルトは、[Colors.blue]。
  final Color? color;

  /// ボタンの内側の余白。デフォルトでは、
  ///
  /// `EdgeInsets.symmetric(horizontal: 6, vertical: 4)` 。
  final EdgeInsetsGeometry padding;

  /// ボタンの角の丸み具合。デフォルトは、`6.0` 。
  final double borderRadius;

  /// ボタンの枠線。　なくてもいい。
  final Border? border;

  /// ボタンの縦幅。
  ///
  /// [child] や [onPressedChild] に合わせたい場合は、`null` を指定し、
  /// [minHeight] （最小値）を指定すること。
  ///
  /// `null` 以外を指定した場合、押されている時も、押されていない時も、同じ [height] が
  /// 適用される。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double? height;

  /// ボタンの横幅。
  ///
  /// [child] や [onPressedChild] に合わせたい場合は、`null` を指定し、
  /// [minWidth] （最小値）を指定すること。
  ///
  /// `null` 以外を指定した場合、押されている時も、押されていない時も、同じ [width] が
  /// 適用される。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double? width;

  /// [BoxConstraints.minHeight]（ボタンの縦幅の最小値）。デフォルトは、`50`。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double minHeight;

  /// [BoxConstraints.minWidth]（ボタンの横幅の最小値）。デフォルトは、`100`。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double minWidth;

  /// 影の色。デフォルトは、[Colors.black38] 。
  final Color shadowColor;

  /// 透明部分をタップした時の挙動。デフォルトでは、[HitTestBehavior.opaque]。
  final HitTestBehavior behaviorOnTransparentArea;

  /// ボタンの枠の中の [child] の配置。デフォルトは、[Alignment.center] 。
  final AlignmentGeometry alignment;

  /// [FittedBox.fit] の値。[child] のフィットのさせ方。
  /// デフォルトは、[BoxFit.scaleDown] 。
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    // ボタンが現在進行形で押されているかどうか
    final isPressed = useState<bool>(false);
    return GestureDetector(
      behavior: behaviorOnTransparentArea,
      // 指が触れた瞬間に、child が onPressedChild に変化してリビルド
      onTapDown: (_) => isPressed.value = true,
      // 指が離れた瞬間に、child が（tempChild に保管していた）元の child に戻ってリビルド
      onTapUp: (_) => isPressed.value = false,
      onTapCancel: () => isPressed.value = false,
      onTap: onPressed,
      onLongPressStart: (LongPressStartDetails details) {
        isPressed.value = true;
        onLongPressStart?.call(details);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        isPressed.value = false;
        onLongPressEnd?.call(details);
      },
      child: AnimatedContainer(
        width: width,
        height: height,
        constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isPressed.value
              ? []
              : [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
        ),
        padding: padding,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            shadowColor.withValues(alpha: 0.06),
            isPressed.value ? BlendMode.srcATop : BlendMode.dst,
          ),
          child: FittedBox(fit: boxFit, alignment: alignment, child: child),
        ),
      ),
    );
  }
}

class ChildDeformableButton extends HookWidget {
  const ChildDeformableButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onPressedChild,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.color = Colors.blue,
    this.isWrapped = false,
    this.borderRadius = 6.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    this.border,
    required this.height,
    required this.width,
    this.minHeight = 50,
    this.minWidth = 100,
    this.shadowColor = Colors.black38,
    this.behaviorOnTransparentArea = HitTestBehavior.opaque,
    this.alignment = Alignment.center,
    this.boxFit = BoxFit.scaleDown,
  }) : willConvertedChild = onPressedChild != null;

  final VoidCallback? onPressed;
  final Function(LongPressStartDetails)? onLongPressStart;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final Widget child;
  final Widget? onPressedChild;
  final bool isWrapped;

  /// ボタンの色（nullable）。デフォルトは、[Colors.blue]。
  final Color? color;

  /// ボタンの内側の余白。デフォルトでは、
  ///
  /// `EdgeInsets.symmetric(horizontal: 6, vertical: 4)` 。
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Border? border;

  /// ボタンの縦幅。
  ///
  /// [child] や [onPressedChild] に合わせたい場合は、`null` を指定し、
  /// [minHeight] （最小値）を指定すること。
  ///
  /// `null` 以外を指定した場合、押されている時も、押されていない時も、同じ [height] が
  /// 適用される。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double? height;

  /// ボタンの横幅。
  ///
  /// [child] や [onPressedChild] に合わせたい場合は、`null` を指定し、
  /// [minWidth] （最小値）を指定すること。
  ///
  /// `null` 以外を指定した場合、押されている時も、押されていない時も、同じ [width] が
  /// 適用される。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double? width;

  /// [BoxConstraints.minHeight]（ボタンの縦幅の最小値）。デフォルトは、`50`。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double minHeight;

  /// [BoxConstraints.minWidth]（ボタンの横幅の最小値）。デフォルトは、`100`。
  ///
  /// [child] や [onPressedChild] は、[Center] でラップされているので、
  /// **Flutter Inspector** で、[child] や [onPressedChild] のサイズを確認すること。
  final double minWidth;

  /// 影の色。
  final Color shadowColor;

  /// [onPressedChild] が指定されているかどうか。
  ///
  /// [build]時に毎回演算しなくていいように、イニシャライザで決定させておく。
  final bool willConvertedChild;

  /// 透明部分をタップした時の挙動。デフォルトでは、[HitTestBehavior.opaque]。
  final HitTestBehavior behaviorOnTransparentArea;

  /// ボタンの枠の中の [child] の配置。デフォルトは、[Alignment.center] 。
  final AlignmentGeometry alignment;

  /// [FittedBox.fit] の値。[child] のフィットのさせ方。
  /// デフォルトは、[BoxFit.scaleDown] 。
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    // ボタンが現在進行形で押されているかどうか
    final isPressed = useState<bool>(false);

    // child を onPressedChild にするかどうか
    final isConvertedChild = isPressed.value && willConvertedChild;
    return GestureDetector(
      behavior: behaviorOnTransparentArea,
      // 指が触れた瞬間に、child が onPressedChild に変化してリビルド
      onTapDown: (_) => isPressed.value = true,
      // 指が離れた瞬間に、child が（tempChild に保管していた）元の child に戻ってリビルド
      onTapUp: (_) => isPressed.value = false,
      onTapCancel: () => isPressed.value = false,
      onTap: onPressed,
      onLongPressStart: (LongPressStartDetails details) {
        isPressed.value = true;
        onLongPressStart?.call(details);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        isPressed.value = false;
        onLongPressEnd?.call(details);
      },
      child: AnimatedContainer(
        width: width,
        height: height,
        constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isPressed.value
              ? []
              : [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
        ),
        padding: padding,
        child: FittedBox(
          fit: boxFit,
          child: isConvertedChild ? onPressedChild : child,
          alignment: alignment,
        ),
      ),
    );
  }
}

/// todo printメソッド [pressable_button.dart]
_print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[pressable_button.dart]　" + s1);
    if (s2 != null) print("[pressable_button.dart]　" + s2);
    if (s3 != null) print("[pressable_button.dart]　" + s3);
    if (s4 != null) print("[pressable_button.dart]　" + s4);
    if (s5 != null) print("[pressable_button.dart]　" + s5);
    print("");
  }
}
