import 'package:flutter/material.dart';

class Palette {
  ///https://colorhunt.co/palette/112b3c205375f66b0eefefef
  static const primaryHex = 0xFF112B3C;
  static const secondaryHex = 0xFF205375;
  static const accentHex = 0xFFF66B0E;
  static const backgroundHex = 0xFFEFEFEF;

  static const primary = Color(primaryHex);
  static const secondary = Color(secondaryHex);
  static const accent = Color(accentHex);
  static const background = Color(backgroundHex);

  static const primaryMaterial = MaterialColor(primaryHex, primarySwatches);
  static const secondaryMaterial =
      MaterialColor(secondaryHex, secondarySwatches);
  static const accentMaterial = MaterialColor(accentHex, accentSwatches);
  static const backgroundMaterial =
      MaterialColor(backgroundHex, backgroundSwatches);

  static const primarySwatches = {
    50: Color.fromRGBO(17, 43, 60, .1),
    100: Color.fromRGBO(17, 43, 60, .2),
    200: Color.fromRGBO(17, 43, 60, .3),
    300: Color.fromRGBO(17, 43, 60, .4),
    400: Color.fromRGBO(17, 43, 60, .5),
    500: Color.fromRGBO(17, 43, 60, .6),
    600: Color.fromRGBO(17, 43, 60, .7),
    700: Color.fromRGBO(17, 43, 60, .8),
    800: Color.fromRGBO(17, 43, 60, .9),
    900: Color.fromRGBO(17, 43, 60, 1),
  };

  static const secondarySwatches = {
    50: Color.fromRGBO(32, 83, 117, .1),
    100: Color.fromRGBO(32, 83, 117, .2),
    200: Color.fromRGBO(32, 83, 117, .3),
    300: Color.fromRGBO(32, 83, 117, .4),
    400: Color.fromRGBO(32, 83, 117, .5),
    500: Color.fromRGBO(32, 83, 117, .6),
    600: Color.fromRGBO(32, 83, 117, .7),
    700: Color.fromRGBO(32, 83, 117, .8),
    800: Color.fromRGBO(32, 83, 117, .9),
    900: Color.fromRGBO(32, 83, 117, 1),
  };

  static const accentSwatches = {
    50: Color.fromRGBO(246, 107, 14, .1),
    100: Color.fromRGBO(246, 107, 14, .2),
    200: Color.fromRGBO(246, 107, 14, .3),
    300: Color.fromRGBO(246, 107, 14, .4),
    400: Color.fromRGBO(246, 107, 14, .5),
    500: Color.fromRGBO(246, 107, 14, .6),
    600: Color.fromRGBO(246, 107, 14, .7),
    700: Color.fromRGBO(246, 107, 14, .8),
    800: Color.fromRGBO(246, 107, 14, .9),
    900: Color.fromRGBO(246, 107, 14, 1),
  };

  static const backgroundSwatches = {
    50: Color.fromRGBO(239, 239, 239, .1),
    100: Color.fromRGBO(239, 239, 239, .2),
    200: Color.fromRGBO(239, 239, 239, .3),
    300: Color.fromRGBO(239, 239, 239, .4),
    400: Color.fromRGBO(239, 239, 239, .5),
    500: Color.fromRGBO(239, 239, 239, .6),
    600: Color.fromRGBO(239, 239, 239, .7),
    700: Color.fromRGBO(239, 239, 239, .8),
    800: Color.fromRGBO(239, 239, 239, .9),
    900: Color.fromRGBO(239, 239, 239, 1),
  };
}
