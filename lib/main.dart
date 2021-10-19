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

class Recaptcha extends StatefulWidget {
  const Recaptcha({Key? key}) : super(key: key);

  @override
  _RecaptchaState createState() => _RecaptchaState();
}

class _RecaptchaState extends State<Recaptcha> {
  final int stringLength = 6;
  final Random random = Random();
  late String solutionString;
  late List<Color> colors;
  late String font;
  bool solved = false;

  late TextEditingController controller;

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

  List<Color> generateBackgroundColors() {
    return List<Color>.generate(
      random.nextInt(100),
      (int index) {
        return Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(
          random.nextDouble(),
        );
      },
    );
  }

  @override
  void initState() {
    controller = TextEditingController();
    List<int> codeUnits = List<int>.generate(6, (_) => random.nextInt(26) + 65);
    solutionString = String.fromCharCodes(codeUnits).splitMapJoin(
      RegExp(r'[A-Z]'),
      onMatch: (Match m) => Random().nextBool() ? m[0]!.toUpperCase() : m[0]!.toLowerCase(),
      onNonMatch: (String s) => s,
    );
    font = getRandomFontName();
    colors = generateBackgroundColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RepaintBoundary(
              child: SizedBox(
                width: 300,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                      ),
                    ),
                    CustomPaint(
                      willChange: false,
                      painter: TextCustomerPainter(
                        solutionString,
                        getRandomFontName(),
                        Random().nextInt(20) + 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  suffixIcon: controller.text.isNotEmpty
                      ? Icon(
                          solved ? Icons.check : Icons.close,
                          color: solved ? Colors.green : Colors.red,
                        )
                      : null,
                  hintText: 'Enter captcha',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 4.0, color: solved ? Colors.green : Colors.red),
                  ),
                ),
                onChanged: (_) {
                  setState(() => solved = controller.text == solutionString);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  tooltip: 'change font',
                  onPressed: () {
                    // TODO(@md-weber): change font
                  },
                  icon: const Icon(
                    Icons.font_download_outlined,
                    size: 25,
                  ),
                ),
                IconButton(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  tooltip: 'new captcha',
                  onPressed: () {
                    // TODO(@md-weber): new captcha
                  },
                  icon: const Icon(
                    Icons.refresh_outlined,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextCustomerPainter extends CustomPainter {
  final String text;
  final String fontFamily;
  final double fontSize;

  TextCustomerPainter(this.text, this.fontFamily, this.fontSize);

  @override
  void paint(Canvas canvas, Size size) {
    List<String> letters = text.split('');

    for (int i = 0; i < letters.length; i++) {
      TextStyle textStyle = TextStyle(
        color: Colors.black,
        fontFamily: fontFamily,
        fontSize: fontSize,
      );
      TextSpan textSpan = TextSpan(
        text: letters[i],
        style: textStyle,
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      double xCenter = (size.width - textPainter.width) / 2;
      double yCenter = (size.height - textPainter.height) / 2;
      Offset offset = Offset(xCenter - 100 + i * 30, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
