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
      home: const Recaptcha(),
    );
  }
}

class Recaptcha extends StatelessWidget {
  const Recaptcha({Key? key}) : super(key: key);
  final stringLength = 6;

// Covert a string to a random capital and small cases
  String getRandomCase(String text) => Random().nextBool() ? text.toUpperCase() : text.toLowerCase();

  /// Generates a random alphabetic character with random letter cases with length of 6(default)
  String captchaTextWithRandomCase(int length) {
    Random random = Random();
    List<int> codeUnits = List<int>.generate(length, (_) => random.nextInt(26) + 65);
    return String.fromCharCodes(codeUnits).splitMapJoin(
      RegExp(r'[A-Z]'),
      onMatch: (Match m) => getRandomCase(m[0]!),
      onNonMatch: (String s) => s,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: TextCustomerPainter(captchaTextWithRandomCase(6)),
        ),
      ),
    );
  }
}

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

class TextCustomerPainter extends CustomPainter {
  final String text;

  TextCustomerPainter(this.text);

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
      final offset = Offset(xCenter + i * 30, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
