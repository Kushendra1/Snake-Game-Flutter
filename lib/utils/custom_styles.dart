import 'dart:ui';

import 'package:flutter/material.dart';

import 'color_manager.dart';

final ButtonStyle primaryBtnStyles = ElevatedButton.styleFrom(
  minimumSize: const Size(300, 50),
  backgroundColor: ColorManager.fromHex("#FF92B9"),
  elevation: 5,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(50),
    ),
  ),
);

final TextStyle sgTextFieldStyles = TextStyle(
    fontSize: 20,
    color: ColorManager.fromHex("#E7EBC5"),
    fontFamily: 'BlackHanSans',
    fontWeight: FontWeight.w700,
    shadows: [Shadow(
      color: ColorManager.fromHex("#4C2719"),
      blurRadius: 5,
      offset: const Offset(4,4),
    ),]
);

