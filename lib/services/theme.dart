import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodenfastTheme {
  // Color backGroundColor1 = const Color(0xFF6A1B9A);
  // Color backGroundColor2 = const Color(0xFFC10685);
  // Color backGroundColor3 = const Color(0xFFF44169);
  // Color backGroundColor4 = const Color(0xFFFF8051);
  Color backGroundColor1 = const Color(0xFF222222);
  Color backGroundColor2 = const Color(0xFF212121);
  Color backGroundColor3 = const Color(0xFF121212);
  Color backGroundColor4 = const Color(0xFF111111);

  int animationDuration = 500;
  Color iconColor = const Color(0xFF000000);
  Color iconColorCrossColor = const Color(0xFFFFFFFF);
  double iconSizeM = 14;
  double iconSizeL = 90;
  double iconSizeLX = 42;

  MaterialColor blackTransparent = const MaterialColor(
    0x05000000,
    <int, Color>{
      50: Color(0x05000000),
      100: Color(0x10000000),
      200: Color(0x20000000),
      300: Color(0x30000000),
      400: Color(0x40000000),
      500: Color(0x50000000),
      600: Color(0x60000000),
      700: Color(0x70000000),
      800: Color(0x80000000),
      900: Color(0x90000000),
    },
  );

  MaterialColor cyanTransparent = const MaterialColor(
    0xAA00BCD4,
    <int, Color>{
      50: Color(0x0500BCD4),
      100: Color(0x2200BCD4),
      200: Color(0x4400BCD4),
      300: Color(0x6600BCD4),
      400: Color(0x8800BCD4),
      500: Color(0xAA00BCD4),
      600: Color(0xBB00BCD4),
      700: Color(0xDD00BCD4),
      800: Color(0xEE00BCD4),
      900: Color(0xFF00BCD4),
    },
  );
  static const int _cyanPrimaryValue = 0xFF00BCD4;

  Widget getBody(Widget child) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backGroundColor1,
              backGroundColor2,
              backGroundColor3,
              backGroundColor4
            ]),
      ),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }

  List<BoxShadow> shadow() {
    return [
      const BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
    ];
  }

  TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 5)
        ])),
    displayMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 4)
        ])),
    displaySmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
        ])),
    headlineLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 5)
        ])),
    headlineMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 4)
        ])),
    headlineSmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
        ])),
    titleLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 5)
        ])),
    titleMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 4)
        ])),
    titleSmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
        ])),
    labelLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16, shadows: [
      BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 5)
    ])),
    labelMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 4)
        ])),
    labelSmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            shadows: [
          BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
        ])),
    bodyLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.white, fontSize: 18, shadows: [
      BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 5)
    ])),
    bodyMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.white, fontSize: 16, shadows: [
      BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 4)
    ])),
    bodySmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.white, fontSize: 14, shadows: [
      BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
    ])),
  );

  TextStyle inputFieldStyle = GoogleFonts.roboto(
      textStyle: TextStyle(color: Colors.white, fontSize: 15, shadows: [
        BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 3)
      ]));

  /*
  TextTheme textTheme2 = TextTheme(
    displayLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold)),
    displayMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold)),
    displaySmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold)),
    headlineLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold)),
    headlineMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold)),
    headlineSmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold)),
    titleLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold)),
    titleMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold)),
    titleSmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold)),
    labelLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.black, fontSize: 16)),
    labelMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold)),
    labelSmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold)),
    bodyLarge: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.black, fontSize: 16)),
    bodyMedium: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.black, fontSize: 14)),
    bodySmall: GoogleFonts.orbitron(
        textStyle: const TextStyle(color: Colors.black, fontSize: 12)),
  );
*/
  IconThemeData iconTheme = const IconThemeData(color: Colors.white, shadows: [
    BoxShadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 4)
  ]);

  /*
  IconThemeData iconTheme2 = const IconThemeData(color: Colors.black, shadows: [
    BoxShadow(color: Colors.white, offset: Offset(0, 0), blurRadius: 4)
  ]);
*/


  Widget circleAvatar(ImageProvider imageProvider, double size) {
    return CircleAvatar(
      child: ClipOval(
        child: Image(
          height: size,
          width: size,
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ButtonStyle positiveButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.green,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  ButtonStyle negativeButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.red[900],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  ButtonStyle warningButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.amber[800],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  ButtonStyle infoButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.blue,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}
