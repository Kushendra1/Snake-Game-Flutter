import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/register/widgets/Sg_edit_text.dart';
import 'package:frontend/network/authentication_service.dart';
import 'package:frontend/utils/validators.dart';

import '../../../navigation/app_router.dart';
import '../../../utils/color_manager.dart';
import '../authentication_method/widgets/HeaderText.dart';
import '../authentication_method/widgets/sg_buttons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController? signInController;

  @override
  Widget build(BuildContext context) {
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
        // the sign in options
        Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HeaderText(
                      text: "Snake",
                      color: ColorManager.headerText,
                      size: 60,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.94,
                          child: SgEditText(
                            onEditText: (controller) {
                              signInController = controller;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SgButton(
                          buttonTitle: "Sign In",
                          onBtnPressed: () {
                            if (signInController != null) {
                              String email = signInController!.text;
                              if (Validator.validateEmail(email)) {
                                AuthService().signInWithEmail(
                                    email: email,
                                    callback: (isEmailSent) {
                                      if (isEmailSent) {
                                        debugPrint("email sent");
                                        Navigator.popAndPushNamed(
                                            context, Routes.MESSAGE_SCREEN,
                                            arguments:
                                                "Please go to your $email inbox and click on the link to sign in.");
                                      } else {
                                        // email not registered
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "Email does not exists. Please register your email before signing in"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, "Okay");
                                                    },
                                                    child: const Text("Okay"))
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    });
                              } else {
                                // invalid email
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Invalid Email. Please enter a valid email"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, "Okay");
                                            },
                                            child: const Text("Okay"))
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      backgroundColor: ColorManager.fromHex("79CDF9"),
                      child: Image.asset(
                        'assets/arrow_back.png',
                        width: 24.0,
                        height: 24.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
