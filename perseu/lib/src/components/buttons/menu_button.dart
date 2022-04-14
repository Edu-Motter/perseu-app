import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  final GestureTapCallback onPressed;
  final String title;
  final Color themeColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            side: MaterialStateProperty.all(const BorderSide(
                color: Colors.teal, width: 1.0, style: BorderStyle.solid)),
            foregroundColor: MaterialStateProperty.all(themeColor),
            overlayColor: MaterialStateProperty.all(themeColor)),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(fontSize: 16)));
  }
}
