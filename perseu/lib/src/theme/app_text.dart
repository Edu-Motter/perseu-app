import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTexto {
  static final TextStyle textoPretoGrande = GoogleFonts.notoSans(
      color: AppCores.preto, fontSize: 24, fontWeight: FontWeight.w400);

  static final TextStyle textoPreto = GoogleFonts.notoSans(
      color: AppCores.preto, fontSize: 20, fontWeight: FontWeight.w400);

  static final TextStyle textoNegritoPreto = GoogleFonts.notoSans(
      color: AppCores.preto, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle textoNegritoVermelho = GoogleFonts.notoSans(
      color: AppCores.vermelho, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle textoVermelho = GoogleFonts.notoSans(
      color: AppCores.vermelho, fontSize: 20, fontWeight: FontWeight.w400);

  static final TextStyle textoVermelhoPequeno = GoogleFonts.notoSans(
      color: AppCores.vermelho, fontSize: 14, fontWeight: FontWeight.w400);

  static final TextStyle textoNegritoBranco = GoogleFonts.notoSans(
      color: AppCores.branco, fontSize: 20, fontWeight: FontWeight.w600);

  static final TextStyle textoBranco = GoogleFonts.notoSans(
      color: AppCores.branco, fontSize: 20, fontWeight: FontWeight.w400);

  static final TextStyle textoBrancoPequeno = GoogleFonts.notoSans(
      color: AppCores.branco, fontSize: 14, fontWeight: FontWeight.w400);
}
