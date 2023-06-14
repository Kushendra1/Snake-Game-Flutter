import 'package:flutter/material.dart';
import 'package:frontend/utils/custom_styles.dart';

import '../../../../utils/color_manager.dart';


class SgEditText extends StatefulWidget {
  final Function(TextEditingController controller) onEditText;

  const SgEditText({required this.onEditText, Key? key}) : super(key: key);

  @override
  State<SgEditText> createState() => _SgEditTextState();
}

class _SgEditTextState extends State<SgEditText> {
  final textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.onEditText(textEditController);
  }

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
        child: TextField(
          controller: textEditController,
          style: sgTextFieldStyles,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(25, 20, 10, 20),
            hintStyle: sgTextFieldStyles,
            hintText: "Enter email",
            filled: true,
            fillColor: ColorManager.buttonPrimaryColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ));
    ;
  }
}
