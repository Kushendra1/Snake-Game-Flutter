import 'package:flutter/material.dart';
import 'package:frontend/utils/color_manager.dart';

import '../../../../utils/custom_styles.dart';
import 'ButtonText.dart';

class SgButton extends StatefulWidget {
  final String buttonTitle;
  final Function() onBtnPressed;

  const SgButton({Key? key, required this.buttonTitle, required this.onBtnPressed}) : super(key: key);

  @override
  State<SgButton> createState() => _SgButtonState();
}

class _SgButtonState extends State<SgButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: ColorManager.fromHex("#40000000"),
            blurRadius: 4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onBtnPressed();
        },
        style: primaryBtnStyles,
        child: ButtonText(
          text: widget.buttonTitle,
          color: ColorManager.fromHex("#E7EBC5"),
        ),
      ),
    );
  }
}
