import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/register/widgets/Sg_edit_text.dart';
import 'package:frontend/navigation/app_router.dart';
import 'package:frontend/network/authentication_service.dart';
import 'package:frontend/utils/validators.dart';

import '../../../utils/color_manager.dart';
import '../authentication_method/widgets/HeaderText.dart';
import '../authentication_method/widgets/sg_buttons.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController? registrationController;

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
                              registrationController = controller;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SgButton(
                          buttonTitle: "Register",
                          onBtnPressed: () {
                            if (registrationController != null) {
                              String email = registrationController!.text;
                              if (Validator.validateEmail(email)) {
                                AuthService().registerWithEmail(email: email, callback: (isEmailSent) {
                                  if (isEmailSent) {
                                    debugPrint("email sent");
                                    Navigator.popAndPushNamed(
                                        context, Routes.MESSAGE_SCREEN,
                                        arguments:
                                        "If the $email exists then you will see a sign in link in your inbox. Please go to your inbox and click on the link to sign in.");
                                  } else {
                                    // email already registered
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: const Text(
                                              "Email registered Already. If you are trying to SignIn go to the SignIn page, otherwise enter a new email"),
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
                      backgroundColor: ColorManager.backBtnColor,
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
