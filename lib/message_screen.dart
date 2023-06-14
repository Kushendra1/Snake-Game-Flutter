import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/HeaderText.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/sg_buttons.dart';
import 'package:frontend/utils/color_manager.dart';
import 'package:frontend/utils/state_helpers.dart';

class MessageScreen extends StatefulWidget {
  final String message;
  const MessageScreen({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    StateHelpers.fromDynamicLink = true;

    return Stack(
      children: [
        // background widget
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Image(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderText(
                text: "Welcome to Snake Game",
                color: ColorManager.fromHex("#E7EBC5"),
                align: TextAlign.center,
                size: 30,
              ),
              const SizedBox(
                height: 50,
              ),
              HeaderText(
                text: widget.message,
                color: ColorManager.fromHex("#FF92B9"),
                align: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }
}
