import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/HeaderText.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/sg_buttons.dart';

import 'package:frontend/navigation/app_router.dart';
import 'package:frontend/network/authentication_service.dart';
import 'package:frontend/utils/color_manager.dart';
import 'package:go_router/go_router.dart';

class AuthenticationMethodScreen extends StatefulWidget {
  const AuthenticationMethodScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationMethodScreen> createState() =>
      _AuthenticationMethodScreenState();
}

class _AuthenticationMethodScreenState
    extends State<AuthenticationMethodScreen> {
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
                        SgButton(
                          buttonTitle: "Google Sign In",
                          onBtnPressed: () {
                            AuthService().sigInWithGoogle();
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SgButton(
                          buttonTitle: "Sign in with email",
                          onBtnPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.SIGN_IN_SCREEN);
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SgButton(
                          buttonTitle: "Register",
                          onBtnPressed: () {
                            Navigator.of(context)
                                .pushNamed(Routes.RESIGER_SCREEN);
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
              child: Container(
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
