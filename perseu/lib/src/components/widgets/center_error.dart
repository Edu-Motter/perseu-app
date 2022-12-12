
import 'package:flutter/material.dart';
import 'package:perseu/src/utils/style.dart';

class CenterError extends StatelessWidget {
  const CenterError({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            color: Style.accent,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Style.background, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
