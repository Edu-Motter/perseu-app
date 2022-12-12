import 'package:flutter/material.dart';
import 'package:perseu/src/utils/style.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Style.accent,
      ),
    );
  }
}
