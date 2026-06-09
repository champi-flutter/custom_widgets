import 'package:custom_widgets/custom_widgets.dart';
import 'package:custom_widgets/custom_widgets/buttons/impressive_button.dart';
import 'package:custom_widgets/custom_widgets/buttons/pressable_button.dart';
import 'package:custom_widgets/custom_widgets/buttons/pressable_3d_button.dart';
import 'package:custom_widgets/custom_widgets/buttons/template_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
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
      builder: (context, _) =>
          MaterialApp(
            title: 'Custom Widgets',
            theme: ThemeData(
              // todo Material3 のオンオフ
              useMaterial3: false,
                colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
      home: const HomeScreen(),
    ),);
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double thickness = 80;

    final List<Widget> test1 = [
      Container(
        width: 100,
        height: 50,
        color: Colors.blue,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text("押", style: TextStyle(
          fontSize: 21,
          color: Colors.white,
        ),),
      ),
      // 余白
      const SizedBox(height: 20),
      PressableButton(
        onPressed: () {
          _print("PressableButtonが押されました。");
        },
        child: Text("PressableButton", style: TextStyle(
          fontSize: 21,
          color: Colors.white,
        ),),
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
        child: Text("押", style: TextStyle(
          fontSize: 21,
          color: Colors.white,
        ),),
        onPressedChild: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("押", style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),),
        ),
        width: 100,
        minWidth: 20,
        height: null,
        minHeight: 50,
        color: Colors.blueAccent,
      ),
      // 余白
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {},
        child: Text("ElevatedButton"),
      ),
      // 余白
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(18),
        child: OutlinedButton(
          child: const Text(
            "はい",
            style: TextStyle(fontSize: 32),
          ),
          style: OutlinedButton.styleFrom(
            fixedSize: const Size(150, 75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            side: BorderSide(
              color: Colors.blue.shade700,
              width: 1.5,
            ),
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
    return Scaffold(
      // backgroundColor: Colors.grey.shade400,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: test2,
        ),
      ),
    );
  }
}

/// todo printメソッド [main.dart]
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

