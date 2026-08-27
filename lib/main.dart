import 'dart:io';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/src/custom_widgets/buttons/custom_popup_menu_button.dart';
import 'package:custom_widgets/src/custom_widgets/widgets/relative_rect_test_wrapper.dart';
import 'package:custom_widgets/src/non_export/popup_test_controller.dart';
import 'package:custom_widgets/src/non_export/private_scaler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        ChangeNotifierProvider<PopupTestController>(
          create: (_) => PopupTestController(),
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411, 914),
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        title: 'Custom Widgets',
        theme: ThemeData(
          // todo Material3 のオンオフ
          useMaterial3: false,
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TestScreen(),
      ),
    );
  }
}

const double appBarHeight = 80;

class TestScreen extends HookWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double thickness = 80;

    final isBorderedAtTest3 = useState<bool>(false);

    final testSwitchState1 = useState<bool>(false);

    final testSwitchState2 = useState<bool>(false);

    final Color testPrimaryColor = testSwitchState1.value
        ? Colors.green
        : Colors.blueAccent;

    final List<Widget> test1 = [
      Container(
        width: 100,
        height: 50,
        color: Colors.blue,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text("押", style: TextStyle(fontSize: 21, color: Colors.white)),
      ),
      // 余白
      const SizedBox(height: 20),
      PressableButton(
        onPressed: () {
          _print("PressableButtonが押されました。");
        },
        child: Text(
          "PressableButton",
          style: TextStyle(fontSize: 21, color: Colors.white),
        ),
        height: null,
        width: null,
      ),
      // 余白
      const SizedBox(height: 20),
      ChildDeformableButton(
        onPressed: () {
          _print("ChildDeformableButtonが押されました。");
        },
        onLongPressStart: (_) {
          _print("長押しを検知しました。");
        },
        onLongPressEnd: (_) {
          _print("ChildDeformableButtonが長押しされました。");
        },
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text("押", style: TextStyle(fontSize: 21, color: Colors.white)),
        onPressedChild: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "押",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        width: 100,
        minWidth: 20,
        height: null,
        minHeight: 50,
        color: Colors.blueAccent,
      ),
      // 余白
      const SizedBox(height: 20),
      TextField(),
      ElevatedButton(onPressed: () {
        Navigator.of(context).pop();
      }, child: Text("ElevatedButton")),
      // 余白
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(18),
        child: OutlinedButton(
          child: const Text("はい", style: TextStyle(fontSize: 32)),
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(150, 75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            side: BorderSide(color: Colors.blue.shade700, width: 1.5),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            _print("はい");
          },
        ),
      ),
      // 余白
      const SizedBox(height: 20),
      TemplateButton(
        text: "text",
        onPressed: () {
          _print("TemplateButton が押されました。");
        },
      ),
      // 余白
      const SizedBox(height: 20),
      TemplateButton.longText(
        text: "TemplateButton",
        onPressed: () {
          _print("TemplateButton.longText が押されました。");
        },
      ),
      // 余白
      const SizedBox(height: 20),
      ImpressiveButton(
        text: "ImpressiveButton",
        onPressed: () {
          _print("ImpressiveButton が押されました。");
        },
      ),
      // 余白
      const SizedBox(height: 20),
      Center(
        child: Labeled3DButton.longText(
          buttonWidth: 160,
          roundness: 40,
          thickness: thickness,
          text: "Labeled3DButton",
          onPressed: () {
            final calc = 0.229 * thickness + 0.125;
            _print("Labeled3DButton が押されました。", "側面: $calc");
          },
        ),
      ),
      // Labeled3DButton(
      //   buttonWidth: 160,
      //   roundness: 40,
      //   thickness: thickness,
      //   text: "Labeled3DButton",
      //   onPressed: (){
      //     final calc = 0.229 * thickness + 0.125;
      //     _print("Labeled3DButton が押されました。", "側面: $calc");
      //   },
      // ),
    ];

    final List<Widget> test2 = [
      // 余白
      const SizedBox(height: 20),
      FlatRaisedButton.sync(
        text: "FlatRaisedButton.sync",
        onPressedSync: () => _print("FullWidthButton（現段階）"),
        backgroundColor: Colors.green,
        height: 90.h,
        width: double.infinity,
        isValid: true,
      ),
      // FullWidthButton.test(
      //   text: "テスト",
      //   onPressedSync: () => _print("FullWidthButton（テスト）"),
      //   backgroundColor: Colors.green,
      // ),
      // 余白
      const SizedBox(height: 20),
      // TestCard(),
      // 余白
      const SizedBox(height: 20),
    ];

    final List<Widget> test3 = [
      TemplateDialogActions(
        textOfDecision: "はい",
        onDecided: () {
          _print("TemplateDialogActions タップ");
          isBorderedAtTest3.value = !isBorderedAtTest3.value;
        },
        textOfReturning: "いいえ",
        decisionBorderColor: isBorderedAtTest3.value
            ? Color(0xFF1976D2)
            : Colors.transparent,
        returningBorderColor: isBorderedAtTest3.value
            ? Colors.black12
            : Colors.transparent,
        returningBackgroundColor: Colors.black12,
        borderRadius: BorderRadius.circular(10),
        onReturn: () {
          _print("TemplateDialogActions タップ");
          isBorderedAtTest3.value = !isBorderedAtTest3.value;
        },
      ),
      OnOffSwitch.onWhite(
        state: testSwitchState1.value,
        primaryColor: Colors.green,
        onChanged: (bool? newState) {
          testSwitchState1.value = newState!;
        },
      ),
      Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.center,
            child: Container(
              height: 100.pHeight(context),
              width: 400.pWidth(context),
              color: testPrimaryColor,
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: OnOffSwitch.onPrimary(
              state: testSwitchState2.value,
              onChanged: (bool? newState) {
                testSwitchState2.value = newState!;
              },
              primaryColor: testPrimaryColor,
            ),
          ),
        ],
      ),
    ];

    // final testRect = useState<Rect?>(null);
    final Rect? testRect = context.select<PopupTestController, Rect?>(
      (controller) => controller.rect,
    );

    final List<Widget> test4 = [
      const SizedBox(height: 20),
      PopupMenuButton(
        child: Icon(Icons.menu),
        itemBuilder: (context) => [
          PopupMenuItem(child: Text("A")),
          PopupMenuItem(child: Text("B")),
          PopupMenuItem(child: Text("C")),
        ],
      ),
      const SizedBox(height: 20),
      PopupMenuButton(
        child: Text("text"),
        itemBuilder: (context) => [
          PopupMenuItem(child: Text("A")),
          PopupMenuItem(child: Text("B")),
          PopupMenuItem(child: Text("C")),
        ],
      ),
      const SizedBox(height: 20),
      Text("a"),
      const SizedBox(height: 20),
      CustomPopupMenuButton(
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          width: 400,
          height: 100,
        ),
        // menuWidth: 250,
        menuItems: [
          PopupMenuItem(child: Text("A")),
          PopupMenuItem(child: Text("B")),
          PopupMenuItem(child: Text("C")),
        ],
      ),
      const SizedBox(height: 20),
      CustomPopupMenuButton(
        viewPoint: 0.8,
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          width: 200,
          height: 100,
        ),
        // menuWidth: 250,
        menuItems: [
          PopupMenuItem(child: Text("A")),
          PopupMenuItem(child: Text("B")),
          PopupMenuItem(child: Text("C")),
        ],
      ),
      const SizedBox(height: 20),
      Align(
        alignment: AlignmentGeometry.centerEnd,
        child: CustomPopupMenuButton(
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            width: 200,
            height: 100,
          ),
          // menuWidth: 250,
          menuItems: [
            PopupMenuItem(child: Text("A")),
            PopupMenuItem(child: Text("B")),
            PopupMenuItem(child: Text("C")),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Align(
        alignment: AlignmentGeometry.centerStart,
        child: CustomPopupMenuButton(
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            width: 200,
            height: 100,
          ),
          // menuWidth: 250,
          menuItems: [
            PopupMenuItem(child: Text("A")),
            PopupMenuItem(child: Text("B")),
            PopupMenuItem(child: Text("C")),
          ],
        ),
      ),
      const SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomPopupMenuButton(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              width: 200,
              height: 100,
            ),
            // menuWidth: 250,
            menuItems: [
              PopupMenuItem(child: Text("A")),
              PopupMenuItem(child: Text("B")),
              PopupMenuItem(child: Text("C")),
              PopupMenuItem(child: Text("D")),
              PopupMenuItem(child: Text("E")),
              PopupMenuItem(child: Text("F")),
            ],
          ),
          CustomPopupMenuButton(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              width: 200,
              height: 100,
            ),
            // menuWidth: 250,
            menuItems: [
              PopupMenuItem(child: Text("A")),
              PopupMenuItem(child: Text("B")),
              PopupMenuItem(child: Text("C")),
              PopupMenuItem(child: Text("D")),
              PopupMenuItem(child: Text("E")),
              PopupMenuItem(child: Text("F")),
            ],
          ),
        ],
      ),
    ];

    return RelativeRectTestWrapper.toScreen(
      rect: testRect,
      leftSideMarker: Colors.purpleAccent,
      screen: Scaffold(
        // backgroundColor: Colors.grey.shade400,
        appBar: AppBar(),
        body: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: test4,
            ),
          ),
          // child: Stack(
          //   children: [
          //     Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: test4,
          //       ),
          //     ),
          //     if (testRect != null)
          //       // Positioned.fromRect(
          //       //   rect: testRect,
          //       //   child: IgnorePointer(
          //       //     child: Container(
          //       //       // 見やすいように半透明の赤色にする
          //       //       color: Colors.red.withValues(alpha: 0.4),
          //       //     ),
          //       //   ),
          //       // ),
          //       Positioned.fill(
          //         child: IgnorePointer(
          //           child: CustomPaint(
          //             painter: TestRectPainter.quadrants(rect: testRect),
          //             size: Size.infinite,
          //             isComplex: false,
          //             willChange: false,
          //           ),
          //         ),
          //       ),
          //     if (testRect != null)
          //       Positioned.fill(
          //         child: IgnorePointer(
          //           child: CustomPaint(
          //             painter: TestRectPainter.quadrants(
          //               rect: Offset.zero & context.screenSize,
          //               filledColor: Colors.green,
          //               alpha: 0.1,
          //               dashedLineColor: Colors.yellow.shade700
          //             ),
          //             size: Size.infinite,
          //             isComplex: false,
          //             willChange: false,
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ),
      ),
    );
  }
}

/// printメソッド [main.dart]
_print(String s1, [String? s2, String? s3, String? s4, String? s5]) {
  if (kDebugMode) {
    print("");
    print("[main.dart]　" + s1);
    if (s2 != null) print("[main.dart]　" + s2);
    if (s3 != null) print("[main.dart]　" + s3);
    if (s4 != null) print("[main.dart]　" + s4);
    if (s5 != null) print("[main.dart]　" + s5);
    print("");
  }
}
