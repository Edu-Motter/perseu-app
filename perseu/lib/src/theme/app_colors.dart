import 'package:flutter/material.dart';

class AppCores {
  static const Color vermelho = Color(0xFFD93535);
  static const Color preto = Color(0xFF444444);
  static const Color branco = Color(0xFFFFFFFF);
  static const MaterialColor vermelhoMaterial =
      MaterialColor(0xFFD93535, variantesVermelho);
}

const Map<int, Color> variantesVermelho = {
  50: Color.fromRGBO(217, 53, 53, .1),
  100: Color.fromRGBO(217, 53, 53, .2),
  200: Color.fromRGBO(217, 53, 53, .3),
  300: Color.fromRGBO(217, 53, 53, .4),
  400: Color.fromRGBO(217, 53, 53, .5),
  500: Color.fromRGBO(217, 53, 53, .6),
  600: Color.fromRGBO(217, 53, 53, .7),
  700: Color.fromRGBO(217, 53, 53, .8),
  800: Color.fromRGBO(217, 53, 53, .9),
  900: Color.fromRGBO(217, 53, 53, 1),
};
