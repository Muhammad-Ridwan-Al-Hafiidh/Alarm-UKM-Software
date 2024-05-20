import 'package:flutter/material.dart';

class CustomColors {
  static Color primaryTextColor = Color.fromARGB(255, 255, 255, 255);
  static Color dividerColor = const Color.fromARGB(137, 255, 255, 255);
  static Color pageBackgroundColor = Color.fromARGB(255, 0, 0, 0);
  static Color homeBackgroundColor = Color.fromARGB(255, 0, 0, 0);
  static Gradient pageBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF000000), // Hitam
      Color(0xFF000080), // Biru gelap
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );
  static Gradient pageBackgroundGradient_alarm = LinearGradient(
    colors: [
      Color.fromARGB(255, 255, 153, 0), // Biru gelap
      Color(0xFF000000), // Hitam
      
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );
  static Gradient pageBackgroundGradient_house = LinearGradient(
    colors: [
      Color(0xFF000000),
      Color.fromARGB(255, 255, 27, 27), // Biru gelap
       // Hitam
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
  static Color menuBackgroundColor = Color.fromARGB(255, 153, 151, 151);
  static Color clockBG = Color.fromARGB(255, 255, 255, 255);
  static Color clockOutline = Color.fromARGB(255, 255, 255, 255);
  static Color? secHandColor = const Color.fromARGB(255, 0, 0, 0);
  static Color minHandStatColor = Color.fromARGB(255, 0, 0, 0);
  static Color minHandEndColor = Color.fromARGB(255, 0, 0, 0);
  static Color hourHandStatColor = Color.fromARGB(255, 0, 0, 0);
  static Color hourHandEndColor = Color.fromARGB(255, 2, 2, 2);
}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
  ];
}
