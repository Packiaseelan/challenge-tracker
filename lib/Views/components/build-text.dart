import 'package:flutter/material.dart';

class BuildText extends StatelessWidget {
  final String text;

  BuildText(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white),
        textScaleFactor: 3,
      ),
    );
  }
}
