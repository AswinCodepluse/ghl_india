import 'package:flutter/material.dart';

class MyTheme {
  /*configurable colors stars*/
  static const Color accent_color = Color(0XFF495867);
  static const Color orange = Color(0xffFF4619);
  static const Color accent_color2 = Color(0xff38DA39);
  static const Color teal_light = Color(0xff73e5ad);
  static const Color accent_color_shadow =
      Color.fromRGBO(229, 65, 28, .40); // this color is a dropshadow of
  static Color soft_accent_color = const Color.fromRGBO(254, 234, 209, 1);
  static Color splash_screen_color =
      Color(0XFF495867); // if not sure , use the same color as accent color
  /*configurable colors ends*/
  /*If you are not a developer, do not change the bottom colors*/
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color dark_purple = Color(0xFF741B47);
  static const Color light_purple2 = Color(0xfffab9d9);
  static const Color light_pink = Color(0xffFEF6FA);
  static Color noColor = const Color.fromRGBO(255, 255, 255, 0);
  static Color light_grey = const Color.fromRGBO(239, 239, 239, 1);
  static Color dark_grey = const Color.fromRGBO(107, 115, 119, 1);
  static Color medium_grey = const Color.fromRGBO(167, 175, 179, 1);
  static Color blue_grey = const Color.fromRGBO(168, 175, 179, 1);
  static Color medium_grey_50 = const Color.fromRGBO(167, 175, 179, .5);
  static const Color grey_153 = Color.fromRGBO(153, 153, 153, 1);
  static Color dark_font_grey = const Color.fromRGBO(62, 68, 71, 1);
  static const Color font_grey = Color.fromRGBO(107, 115, 119, 1);
  static const Color textfield_grey = Color.fromRGBO(209, 209, 209, 1);
  static Color golden = const Color.fromRGBO(255, 168, 0, 1);
  static Color black = Colors.black;
  static Color amber = const Color.fromRGBO(254, 234, 209, 1);
  static Color amber_medium = const Color.fromRGBO(254, 240, 215, 1);
  static Color golden_shadow = const Color.fromRGBO(255, 168, 0, .4);
  static Color green = Colors.green;
  static Color green_new = const Color(0xFF38761D);
  static Color? green_light = Colors.green[200];
  static Color light_brown = Color(0XFFDAD5BD);
  static Color mild_green = Color(0xFFD9EAC2);
  static const Color pale = Color(0xFFFAF9DE);
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;

  //testing shimmer
  /*static Color shimmer_base = Colors.redAccent;
  static Color shimmer_highlighted = Colors.yellow;*/

  // gradient color for coupons
  static const Color gigas = Color.fromRGBO(95, 74, 139, 1);
  static const Color blue_light2 = Color(0xffd7d8fa);
  static const Color light_purple = Color(0xffeee5ff);
  static const Color polo_blue = Color.fromRGBO(152, 179, 209, 1);
  static const Color indigo = Colors.indigo;
  static const Color light_blue = Color(0xFFb5def4);

  static const Color blue_chill = Color.fromRGBO(71, 148, 147, 1);
  static const Color cruise = Color.fromRGBO(124, 196, 195, 1);
  static const Color red = Colors.red;
  static const Color brick_red = Color.fromRGBO(191, 25, 49, 1);
  static const Color cinnabar = Color.fromRGBO(226, 88, 62, 1);
  static const Color tealDark = Color(0xff03331F);
  static const Color teal = Color(0xff065535);
  static const Color couponFirstColor = Color(0xFF4C1A75);
  static const Color couponSecondColor = Color(0xFF00A8AA);

  static const PrimaryColor = Color(0xffea4b4b);
  static const PrimaryLightColor = Color(0xffF7F9F9);
  static const CardBackgroundColor = Color(0xfff3f4f4);
  static const PrimaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
  );
  static const SecondaryColor = Color(0xFF979797);
  static const SecondaryColorDark = Color(0xff292929);
  static const mainColor = Color(0xFFD92B31);

  static TextTheme textTheme1 = const TextTheme(
    bodyLarge: TextStyle(fontFamily: "Poppins", fontSize: 14),
    bodyMedium: TextStyle(fontFamily: "Poppins", fontSize: 12),
  );

  static LinearGradient linearGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0XFFE94444), Color(0XFF262530)],
    );
  }

  static LinearGradient linearGradient1() {
    return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0XFFE94444), Color(0XFF262530)],
    );
  }

  static LinearGradient buildLinearGradient1() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [MyTheme.cinnabar, MyTheme.brick_red],
    );
  }
}
