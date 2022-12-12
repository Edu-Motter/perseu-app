import 'package:flutter/material.dart';
import 'package:perseu/src/utils/style.dart';

class CenterRoundedContainer extends StatelessWidget {
  const CenterRoundedContainer({
    Key? key,
    required this.child,
    this.color = Style.accent,
  }) : super(key: key);

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 18.0,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
