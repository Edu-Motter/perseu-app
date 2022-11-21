import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  static const foregroundColor = Colors.teal;
  static const backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .20,
      width: MediaQuery.of(context).size.width * .40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          side: MaterialStateProperty.all(
              const BorderSide(color: foregroundColor, width: 2)),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Icon(icon, color: foregroundColor, size: 32),
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                    style:
                        const TextStyle(color: foregroundColor, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
