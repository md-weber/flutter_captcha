import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Recaptcha(),
    );
  }
}

class Recaptcha extends StatefulWidget {
  Recaptcha({Key? key}) : super(key: key);

  @override
  _RecaptchaState createState() => _RecaptchaState();
}

class _RecaptchaState extends State<Recaptcha> {
  final stringLength = 6;
  final random = Random();
  late String solutionString;
  late List<Color> colors;
  bool solved = false;

  List<Color> generateBackgroundColors() {
    return List<Color>.generate(
      random.nextInt(100),
      (index) {
        return Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(
          random.nextDouble(),
        );
      },
    );
  }

  @override
  void initState() {
    List<int> codeUnits = List<int>.generate(6, (_) => random.nextInt(26) + 65);
    solutionString = String.fromCharCodes(codeUnits).splitMapJoin(
      RegExp(r'[A-Z]'),
      onMatch: (Match m) => getRandomCase(m[0]!),
      onNonMatch: (String s) => s,
    );
    colors = generateBackgroundColors();
    super.initState();
  }

  String getRandomCase(String text) =>
      Random().nextBool() ? text.toUpperCase() : text.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RepaintBoundary(
              child: SizedBox(
                width: 300,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                      ),
                    ),
                    CustomPaint(
                      willChange: false,
                      painter: TextCustomerPainter(solutionString),
                    )
                  ],
                ),
              ),
            ),
            RepaintBoundary(
              child: TextField(
                onChanged: (value) {
                  setState(() => solved = value == solutionString);
                },
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: solved
                  ? Container(
                      color: Colors.green,
                    )
                  : Container(color: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}

class TextCustomerPainter extends CustomPainter {
  final String text;

  TextCustomerPainter(this.text);

  /// Return random font name
  String getRandomFontName() {
    List<String> fontNames = <String>[
      'captchaFonts',
      'Norefund',
      'Dompleng',
      'Custom',
    ];
    return fontNames[Random().nextInt(fontNames.length)];
  }

  @override
  void paint(Canvas canvas, Size size) {
    List<String> letters = text.split('');

    for (var i = 0; i < letters.length; i++) {
      final textStyle = TextStyle(
        color: Colors.black,
        fontFamily: getRandomFontName(),
        fontSize: Random().nextInt(20) + 30,
      );
      final textSpan = TextSpan(
        text: letters[i],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      final xCenter = (size.width - textPainter.width) / 2;
      final yCenter = (size.height - textPainter.height) / 2;
      final offset = Offset(xCenter - 100 + i * 30, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
