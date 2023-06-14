import 'package:flutter/material.dart';
import 'package:frontend/utils/color_manager.dart';

class ButtonText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  TextAlign align;

  ButtonText({super.key,
    this.color,
    required this.text,
    this.size = 20,
    this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontFamily: 'BlackHanSans',
          fontWeight: FontWeight.w700,
          shadows: [Shadow(
            color: ColorManager.fromHex("#4C2719"),
            blurRadius: 5,
            offset: const Offset(4,4),
          ),]
      ),
      textAlign: align,
    );
  }
}
