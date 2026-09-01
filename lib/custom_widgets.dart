library custom_widgets;

// 作成したWidgetファイルをエクスポートする
// extensions
export "src/extensions/extensions_build_context.dart";
export "src/extensions/navigator_extensions.dart";

// custom_widgets
// /button
export "src/custom_widgets/buttons/formal_button.dart";

export "src/custom_widgets/buttons/flat_raised_button.dart";

export "src/custom_widgets/buttons/impressive_button.dart";

export "src/custom_widgets/buttons/pressable_button.dart";

export "src/custom_widgets/buttons/pressable_3d_button.dart";

export "src/custom_widgets/buttons/template_button.dart";

// 2026/06/11 追加
export 'src/custom_widgets/buttons/buttons_custom_enumerations.dart';

// 2026/07/04 追加
export 'src/custom_widgets/buttons/on_off_switch.dart';

// 2026/08/27 追加
export 'src/custom_widgets/buttons/tap_area_expansion.dart';
export 'src/custom_widgets/buttons/custom_popup_menu_button.dart';

// /overlays
export "src/custom_widgets/overlays/ensured_immutable_dependency_dialog.dart";
export 'src/custom_widgets/overlays/alert_dialog_template.dart';
export 'src/custom_widgets/overlays/sized_simple_dialog.dart';

// /texts
export "src/custom_widgets/texts/utilized_text.dart";

// /widgets
export "src/custom_widgets/widgets/loadable_widget.dart";

// custom_hooks
export 'src/custom_hooks/use_listenable_text_controller.dart';
export 'src/custom_hooks/use_non_reactive_text_controller.dart';
export 'src/custom_hooks/use_text_focus_controller.dart';

// todo 新しいカスタムWidgetを追加した場合、ここに記述する