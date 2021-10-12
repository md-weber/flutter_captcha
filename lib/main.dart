import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

class Recaptcha extends StatelessWidget {
  const Recaptcha({Key? key}) : super(key: key);
  final stringLength = 6;

  String randomStringGenerator(int length) {
    /// Generates a random alphabetic character length of 6(default)
    List<int> codeUnits = List<int>.generate(length, (_) {
      return Random().nextInt(26) + 65;
    });
    return String.fromCharCodes(codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Transform.rotate(
            angle: 3,
            child: CustomPaint(
              painter: TextCustomerPainter(randomStringGenerator(6)),
            ),
          ),
        ),
      ),
    );
  }
}

class TextCustomerPainter extends CustomPainter {
  final String text;

  TextCustomerPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    List<String> letters = text.split("");

    for (var i = 0; i < letters.length; i++) {
      final textStyle = TextStyle(
        color: Colors.black,
        fontSize: Random().nextInt(20) + 10,
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
    throw false;
  }
}
