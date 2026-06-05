import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

/// 特定の依存先のインスタンスが不変であることを保証するラッパークラス。
class EnsuredImmutableDependencyDialog<T> extends HookWidget {
  const EnsuredImmutableDependencyDialog({super.key, required this.dialog});

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    final instance = context.select<T, T>((T dependency) => dependency);
    final initialInstance = useMemoized(() => instance);
    assert(
      identical(instance, initialInstance),
      '${T.toString()} のインスタンスが変更されました。このクラスではインスタンスの不変性が期待されています。',
    );
    return dialog;
  }
}

/// 特定の依存先のインスタンスが不変であることを保証するラッパークラス。
class Ensured2ImmutableDependenciesDialog<A, B> extends HookWidget {
  const Ensured2ImmutableDependenciesDialog({super.key, required this.dialog});

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    final instanceA = context.select<A, A>((A dependency) => dependency);
    final instanceB = context.select<B, B>((B dependency) => dependency);
    final initialInstanceA = useMemoized(() => instanceA);
    final initialInstanceB = useMemoized(() => instanceB);
    assert(
      identical(instanceA, initialInstanceA),
      '${A.toString()} のインスタンスが変更されました。このクラスではインスタンスの不変性が期待されています。',
    );
    assert(
      identical(instanceB, initialInstanceB),
      '${B.toString()} のインスタンスが変更されました。このクラスではインスタンスの不変性が期待されています。',
    );
    return dialog;
  }
}

/// 特定の依存先のインスタンスが不変であることを保証するラッパークラス。
class Ensured3ImmutableDependenciesDialog<A, B, C> extends HookWidget {
  const Ensured3ImmutableDependenciesDialog({super.key, required this.dialog});

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    final instanceA = context.select<A, A>((A dependency) => dependency);
    final instanceB = context.select<B, B>((B dependency) => dependency);
    final instanceC = context.select<C, C>((C dependency) => dependency);
    final initialInstanceA = useMemoized(() => instanceA);
    final initialInstanceB = useMemoized(() => instanceB);
    final initialInstanceC = useMemoized(() => instanceC);
    assert(
      identical(instanceA, initialInstanceA),
      '${A.toString()} のインスタンスが変更されました。このクラスではインスタンスの不変性が期待されています。',
    );
    assert(
      identical(instanceB, initialInstanceB),
      '${B.toString()} のインスタンスが変更されました。このクラスではインスタンスの不変性が期待されています。',
    );
    assert(
      identical(instanceC, initialInstanceC),
      '${C.toString()} のインスタンスが変更されました。このクラスではインスタンスの不変性が期待されています。',
    );
    return dialog;
  }
}
